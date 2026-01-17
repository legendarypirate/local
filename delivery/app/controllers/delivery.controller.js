const db = require("../models");
const Delivery = db.deliveries;
const Op = db.Sequelize.Op;
const User = db.users;
const Status = db.statuses;
const Order = db.orders;
const Good = db.goods;
const DeliveryItem = db.delivery_items;


const generateDeliveryId = async () => {
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  let deliveryId;
  let exists = true;

  while (exists) {
    deliveryId = Array.from({ length: 10 }, () => characters[Math.floor(Math.random() * characters.length)]).join('');
    const existing = await Delivery.findOne({ where: { delivery_id: deliveryId } });
    if (!existing) exists = false;
  }

  return deliveryId;
};

exports.status = async (req, res) => {
  const { status_id, delivery_ids } = req.body;

  if (!status_id || !Array.isArray(delivery_ids) || delivery_ids.length === 0) {
    return res.status(400).json({
      success: false,
      message: "Driver ID and a list of delivery IDs are required.",
    });
  }

  try {
    // Bulk update the deliveries
    await Delivery.update(
      {
        status: status_id,      // Set the status to 2 (or any value that represents the allocated state)
      },
      {
        where: {
          id: delivery_ids, // Filter by the selected delivery IDs
        },
      }
    );

    res.json({
      success: true,
      message: "Deliveries allocated and status updated successfully.",
    });
  } catch (error) {
    console.error("Error allocating deliveries:", error);
    res.status(500).json({
      success: false,
      message: "Server error while allocating deliveries.",
    });
  }
};

// GET /api/delivery/:id/history
exports.getDeliveryHistory = async (req, res) => {
  const deliveryId = req.params.id;

  try {
    const histories = await db.histories.findAll({
      where: { delivery_id: deliveryId },
      include: [
        {
          model: db.users,
          as: 'driver',
          attributes: ['id', 'username', 'phone']
        },
        {
          model: db.statuses,
          as: 'status_name',
          attributes: ['id', 'status', 'color'] // Include color here
        }
      ],
      order: [['createdAt', 'DESC']],
    });

    res.json({
      success: true,
      data: histories,
    });
  } catch (err) {
    console.error("Error fetching history:", err);
    res.status(500).json({
      success: false,
      message: "Server error while fetching history.",
    });
  }
};


exports.getStatusCounts = async (req, res) => {
  try {
    const { merchant_id } = req.query; // <-- Get from frontend

    const where = { is_deleted: false }; // Exclude deleted deliveries
    if (merchant_id) {
      where.merchant_id = merchant_id;
    }

    const counts = await Delivery.findAll({
      attributes: [
        'status',
        [Delivery.sequelize.fn('COUNT', Delivery.sequelize.col('status')), 'count']
      ],
      where,
      group: ['status'],
    });

    const result = {};
    counts.forEach((row) => {
      result[row.status] = parseInt(row.dataValues.count, 10);
    });

    res.json({
      success: true,
      data: result,
    });
  } catch (error) {
    console.error('Error fetching status counts:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

exports.statistic = async (req, res) => {
  try {
    const merchantId = req.query.merchant_id;

    const now = new Date();
    const todayStart = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(), 0, 0, 0));
    const todayEnd = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(), 23, 59, 59, 999));
    

    // Define base where condition
    const dateCondition = {
      createdAt: { [Op.between]: [todayStart, todayEnd] },
    };

    // Add merchant_id if exists
    const whereDelivery = merchantId ? { merchant_id: merchantId, ...dateCondition } : dateCondition;
    const whereSuccess = merchantId
      ? { merchant_id: merchantId, status: 3, ...dateCondition }
      : { status: 3, ...dateCondition };
    const whereOrder = merchantId ? { merchant_id: merchantId, ...dateCondition } : dateCondition;
    const whereGood = merchantId ? { merchant_id: merchantId, ...dateCondition } : dateCondition;

    const [deliveryCount, successCount, orderCount, goodsCount] = await Promise.all([
      Delivery.count({ where: whereDelivery }),
      Delivery.count({ where: whereSuccess }),
      Order.count({ where: whereOrder }),
      Good.count({ where: whereGood }),
    ]);

    const successRate =
      deliveryCount > 0 ? parseFloat(((successCount / deliveryCount) * 100).toFixed(2)) : 0;

    res.json({
      success: true,
      deliveries_today: deliveryCount,
      successful_deliveries: successCount,
      success_rate_percent: successRate,
      orders_today: orderCount,
      goods_today: goodsCount,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      success: false,
      message: 'Failed to get statistics',
      error: err.message,
    });
  }
};

// Create and Save a new Categories
exports.create = async (req, res) => {
  if (
    !req.body.merchant_id ||
    !req.body.phone ||
    !req.body.address ||
    !req.body.comment
  ) {
    return res.status(400).send({
      message: "Content can not be empty!",
    });
  }

  const t = await db.sequelize.transaction();

  try {
    const delivery_id = await generateDeliveryId();

    const newDel = {
      delivery_id,
      merchant_id: req.body.merchant_id,
      phone: req.body.phone,
      address: req.body.address,
      dist_id: req.body.dist_id,
      status: 1,
      is_paid: req.body.is_paid ?? false,
      is_rural: req.body.is_rural ?? false,
      price: req.body.price,
      comment: req.body.comment,
    };

    const delivery = await Delivery.create(newDel, { transaction: t });

 await db.histories.create(
      {
        merchant_id: req.body.merchant_id,
        delivery_id: delivery.id,
        driver_id: null, 
        status: 1, // allowed since allowNull = true

        // allowed since allowNull = true
      },
      { transaction: t }
    );

    if (req.body.items && Array.isArray(req.body.items)) {
      const itemsToInsert = req.body.items.map((item) => ({
        delivery_id: delivery.id,
        good_id: item.good_id,
        quantity: item.quantity || 1,
      }));

      await DeliveryItem.bulkCreate(itemsToInsert, { transaction: t });

      // Reduce stock for each good
      for (const item of req.body.items) {
        const quantity = item.quantity || 1;
        await db.goods.increment(
          { stock: -quantity },
          {
            where: { id: item.good_id },
            transaction: t,
          }
        );
      }
    }

    await t.commit();

    res.json({ success: true, data: delivery });
  } catch (err) {
    await t.rollback();
    console.error(err);
    res.status(500).json({
      success: false,
      message:
        err.message || "Some error occurred while creating the Delivery.",
    });
  }
};


exports.getItemsByDeliveryId = async (req, res) => {
  const deliveryId = req.params.deliveryId;

  if (!deliveryId) {
    return res.status(400).json({ success: false, message: "Delivery ID is required" });
  }

  try {
    const items = await db.delivery_items.findAll({
      where: { delivery_id: deliveryId },
      include: [
        {
          model: db.goods,
          as: 'good',            // matches alias in belongsTo association
          attributes: ['name', ],  // choose fields you want
        }
      ],
    });
    

    res.json({ success: true, data: items });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      success: false,
      message: err.message || "Error fetching delivery items",
    });
  }
};

exports.importExcelDeliveries = async (req, res) => {
    const { deliveries } = req.body;
  
    try {
      const results = [];
  
      for (const item of deliveries) {
        const merchant = await User.findOne({ where: { username: item.merchantName } });
        if (!merchant) continue;
        const delivery_id = await generateDeliveryId();

        const newDelivery = await Delivery.create({
          delivery_id, // include the unique ID
          merchant_id: merchant.id,
          phone: item.phone,
          address: item.address,
          price: parseFloat(item.price),
          comment: item.comment,
          status: 1, // Default status (e.g. "шинэ")
          driver_id: 0, // Optional
        });
  
        results.push(newDelivery);
      }
  
      res.status(200).json({ success: true, inserted: results.length });
    } catch (err) {
      console.error('Import error:', err);
      res.status(500).json({ success: false, message: 'Failed to import deliveries.' });
    }
  };

  //80989497

 exports.allocateDeliveries = async (req, res) => {
  const { driver_id, delivery_ids } = req.body;

  if (!driver_id || !Array.isArray(delivery_ids) || delivery_ids.length === 0) {
    return res.status(400).json({
      success: false,
      message: "Driver ID and a list of delivery IDs are required.",
    });
  }

  const t = await db.sequelize.transaction();

  try {
    // 🔹 Bulk update deliveries: assign driver and update status
    await Delivery.update(
      {
        driver_id,
        status: 2, // allocated
      },
      {
        where: { id: delivery_ids },
        transaction: t,
      }
    );

    // 🔹 Fetch deliveries to get merchant_id for each (for history)
    const deliveries = await Delivery.findAll({
      where: { id: delivery_ids },
      attributes: ["id", "merchant_id"],
      transaction: t,
    });

    // 🔹 Create a history record for each delivery with status = 2
    const historyRecords = deliveries.map((d) => ({
      merchant_id: d.merchant_id,
      delivery_id: d.id,
      driver_id,
      status: 2, // allocated
    }));

    await db.histories.bulkCreate(historyRecords, { transaction: t });

    await t.commit();

    res.json({
      success: true,
      message: "Deliveries allocated, status updated, and history recorded successfully.",
    });
  } catch (error) {
    await t.rollback();
    console.error("Error allocating deliveries:", error);
    res.status(500).json({
      success: false,
      message: "Server error while allocating deliveries.",
    });
  }
};

  
// Retrieve all Categories from the database.
exports.findAll = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;

    const {
      merchant_id,
      status_ids,
      driver_id,
      phone,
      dist_id,
      start_date,
      end_date,
    } = req.query;

    // 🧩 Build WHERE clause
    const where = {
      [Op.or]: [{ is_deleted: false }, { is_deleted: null }],
    };

    if (merchant_id) where.merchant_id = merchant_id;
    if (driver_id) where.driver_id = driver_id;
    if (dist_id) where.dist_id = dist_id;
    if (phone) where.phone = { [Op.like]: `%${phone}%` };

    if (status_ids) {
      const statusArray = status_ids.split(",").map(Number);
      if (statusArray.length > 0) where.status = { [Op.in]: statusArray };
    }

    // 🗓️ Date Filter (Ulaanbaatar Time)
    const tzOffsetMinutes = 8 * 60; // GMT+8
    let filterStart, filterEnd;

    if (start_date && end_date) {
      // Convert to Mongolia local time explicitly
      filterStart = new Date(`${start_date}T00:00:00+08:00`);
      filterEnd = new Date(`${end_date}T23:59:59+08:00`);

      where.delivered_at = { [Op.between]: [filterStart, filterEnd] };
    }

    // 🔍 Query database
    const { count, rows } = await Delivery.findAndCountAll({
      where,
      limit,
      offset,
      include: [
        { model: User, as: "merchant", attributes: ["username"] },
        { model: Status, as: "status_name", attributes: ["status", "color"] },
        { model: User, as: "driver", attributes: ["username"] },
      ],
      order: [["id", "DESC"]],
    });

    // 🧾 Response
    res.status(200).json({
      success: true,
      data: rows.map((d) => d.toJSON()),
      pagination: {
        total: count,
        page,
        limit,
      },
    });
  } catch (error) {
    console.error("findAll error:", error);
    res
      .status(500)
      .json({ success: false, message: "Server error", error: error.message });
  }
};
exports.findAllWithDate = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;

    const { startDate, endDate, driverId, merchantId } = req.query;

    const where = {};

    // Date range (inclusive, Ulaanbaatar time)
    if (startDate && endDate) {
      const start = new Date(`${startDate}T00:00:00+08:00`);
      const end = new Date(`${endDate}T23:59:59+08:00`);

      where.delivered_at = {
        [Op.gte]: start,
        [Op.lte]: end,
      };
    }

    // Exclude statuses 1 and 2
      // Only status = 3 or 7
where.status = {
  [Op.in]: [3, 7],
};


    // Only non-reported deliveries
   // where.is_reported = false;

    if (driverId) {
      where.driver_id = driverId;
    }

    if (merchantId) {
      where.merchant_id = merchantId;
    }

    const { count, rows } = await Delivery.findAndCountAll({
      where,
      limit,
      offset,
      include: [
        {
          model: User,
          as: 'merchant',
          attributes: ['username'],
        },
        {
          model: Status,
          as: 'status_name',
          attributes: ['status', 'color'],
        },
        {
          model: User,
          as: 'driver',
          attributes: ['username'],
        },
      ],
      order: [['id', 'DESC']],
    });

    const formattedDeliveries = rows.map((delivery) => delivery.toJSON());

    res.status(200).json({
      success: true,
      data: formattedDeliveries,
      pagination: {
        total: count,
        page,
        limit,
      },
    });
  } catch (error) {
    console.error("findAllWithDate error:", error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};


// Find a single Categories with an id
exports.findOne = async (req, res) => {
  const id = req.params.id;
  
  try {
    const delivery = await Delivery.findOne({
      where: { id },
      include: [
        {
          model: User,
          as: 'merchant',     // alias in model associations
          attributes: ['id', 'username','phone', 'shop_phone'] // select only what you need
        },
        {
          model: Status,
          as: 'status_name',   // alias for status table
          attributes: ['id', 'status']
        }
      ]
    });

    if (delivery) {
      res.json({
        success: true,
        data: delivery
      });
    } else {
      res.status(404).json({ success: false, message: 'Delivery not found' });
    }
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};


// Update a Categories by the id in the request
exports.update = async (req, res) => {
  const id = req.params.id;

  // Validate request (ensure at least one field is provided)
  if (!req.body.phone && !req.body.address && !req.body.price && !req.body.comment) {
    return res.status(400).json({
      success: false,
      message: "Request body cannot be empty. At least one field is required.",
    });
  }

  const t = await db.sequelize.transaction();

  try {
    // Prepare the data for updating
    const updateData = {};
    if (req.body.phone !== undefined) updateData.phone = req.body.phone;
    if (req.body.address !== undefined) updateData.address = req.body.address;
    if (req.body.price !== undefined) updateData.price = req.body.price;
    if (req.body.comment !== undefined) updateData.comment = req.body.comment;

    // Update the delivery entry in the database
    const [num] = await Delivery.update(updateData, { 
      where: { id: id },
      transaction: t
    });

    if (num === 0) {
      await t.rollback();
      return res.status(404).json({
        success: false,
        message: "Delivery not found or no changes were made.",
      });
    }

    // Handle items update if provided
    if (req.body.items && Array.isArray(req.body.items)) {
      // Get existing items
      const existingItems = await DeliveryItem.findAll({
        where: { delivery_id: id },
        transaction: t
      });

      // Get existing item IDs from request
      const providedItemIds = req.body.items
        .filter(item => item.id)
        .map(item => item.id);

      // Delete items that are not in the provided list
      const itemsToDelete = existingItems.filter(
        item => !providedItemIds.includes(item.id)
      );

      for (const itemToDelete of itemsToDelete) {
        // Restore stock for deleted items
        if (itemToDelete.good_id) {
          await Good.increment(
            { stock: itemToDelete.quantity },
            {
              where: { id: itemToDelete.good_id },
              transaction: t
            }
          );
        }
        await DeliveryItem.destroy({
          where: { id: itemToDelete.id },
          transaction: t
        });
      }

      // Update or create items
      for (const item of req.body.items) {
        if (item.id) {
          // Update existing item
          const existingItem = existingItems.find(ei => ei.id === item.id);
          if (existingItem) {
            const quantityDiff = item.quantity - existingItem.quantity;
            
            // Update quantity
            await DeliveryItem.update(
              { quantity: item.quantity },
              { where: { id: item.id }, transaction: t }
            );

            // Adjust stock if quantity changed
            if (quantityDiff !== 0 && item.good_id) {
              await Good.increment(
                { stock: -quantityDiff },
                {
                  where: { id: item.good_id },
                  transaction: t
                }
              );
            }
          }
        } else {
          // Create new item
          await DeliveryItem.create(
            {
              delivery_id: id,
              good_id: item.good_id,
              quantity: item.quantity || 1,
            },
            { transaction: t }
          );

          // Reduce stock for new item
          if (item.good_id) {
            await Good.increment(
              { stock: -(item.quantity || 1) },
              {
                where: { id: item.good_id },
                transaction: t
              }
            );
          }
        }
      }
    }

    await t.commit();

    // Fetch the updated delivery
    const updatedDelivery = await Delivery.findByPk(id, {
      include: [
        { model: User, as: "merchant", attributes: ["username"] },
        { model: Status, as: "status_name", attributes: ["status", "color"] },
        { model: User, as: "driver", attributes: ["username"] },
      ]
    });

    res.json({
      success: true,
      message: "Delivery was updated successfully.",
      data: updatedDelivery,
    });
  } catch (err) {
    await t.rollback();
    console.error("Error updating delivery:", err);
    res.status(500).json({
      success: false,
      message: "Error updating delivery with id=" + id,
      error: err.message,
    });
  }
};


exports.infoupdate = (req, res) => {
  const id = req.params.id;

  // Validate request (ensure at least one field is provided)
  if (
    !req.body.lookfor &&
    !req.body.area &&
    !req.body.size &&
    !req.body.request
  ) {
    return res.status(400).json({
      success: false,
      message: "Request body cannot be empty. At least one field is required.",
    });
  }

  // Prepare the data for updating
  const updateData = {
 
    lookfor: req.body.lookfor || null,
    area: req.body.area || null,
    size: req.body.size || null,
    request: req.body.request || null,
  };
    console.log(updateData);
  // Update the category entry in the database
  category.update(updateData, { where: { id: id } })
    .then((num) => {
      if (num[0] === 1) {
        return category.findByPk(id); // Fetch the updated category
      } else {
        throw new Error("Category not found or no changes were made.");
      }
    })
    .then((updatedCategory) => {
      res.json({
        success: true,
        message: "Category was updated successfully.",
        data: updatedCategory,
      });
    })
    .catch((err) => {
      res.status(500).json({
        success: false,
        message: "Error updating category with id=" + id,
        error: err.message,
      });
    });
};


// Delete a category with the specified id in the request
// Delete a category with the specified id in the request
exports.delete = (req, res) => {
  const id = req.params.id;

  Delivery.destroy({
    where: { id: id }
  })
    .then(num => {
      if (num == 1) {
        res.json({ success: true, message: "Category was deleted successfully!" });

      } else {
        res.send({
          message: `Cannot delete Categories with id=${id}. Maybe category was not found!`
        });
      }
    })
    .catch(err => {
      res.status(500).send({
        message: "Could not delete category with id=" + id
      });
    });
};

exports.deleteMultiple = async (req, res) => {
  const { ids } = req.body;
  try {
    await Delivery.update(
      { is_deleted: true },
      { where: { id: ids } }
    );
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};


// Delete all Tutorials from the database.
exports.deleteAll = (req, res) => {
  Delivery.destroy({
    where: {},
    truncate: false
  })
    .then(nums => {
      res.send({ message: `${nums} category were deleted successfully!` });
    })
    .catch(err => {
      res.status(500).send({
        message:
          err.message || "Some error occurred while removing all category."
      });
    });
};


// find all published Categories
exports.findAllPublished = (req, res) => {
  category.findAll({ where: { published: true } })
    .then(data => {
      res.send(data);
    })
    .catch(err => {
      res.status(500).send({
        message:
          err.message || "Some error occurred while retrieving category."
      });
    });
};
