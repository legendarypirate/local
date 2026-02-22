const db = require("../models");
const Delivery = db.deliveries;
const User = db.users;
const Status = db.statuses;
const Op = db.Sequelize.Op;
const { fn, col, literal } = db.Sequelize;
const DeliveryItem = db.delivery_items;
const Good = db.goods;
const moment = require("moment-timezone"); // <-- Add this line

exports.findDriverDeliveriesWithStatus = (req, res) => {
  const driverId = req.params.id;

  Delivery.findAll({
      where: {
          driver_id: driverId,
          status: 2
      }
  })
  .then(data => {
      res.send({
          success: true,
          data: data
      });
  })
  .catch(err => {
      res.status(500).send({
          message: err.message || "Some error occurred while retrieving deliveries."
      });
  });
};

exports.findWithStatus = async (req, res) => {
  const driverId = req.params.id;
  const status = parseInt(req.params.status, 10);

  if (isNaN(status)) {
    return res.status(400).send({ success: false, message: "Invalid status parameter" });
  }

  // Default: last 7 days in Asia/Ulaanbaatar timezone
  const endDate = moment.tz("Asia/Ulaanbaatar").endOf("day").toDate(); // Today 23:59:59
  const startDate = moment.tz("Asia/Ulaanbaatar").subtract(6, 'days').startOf("day").toDate(); 
  // 7 days total: today + previous 6 days

  try {
    const data = await Delivery.findAll({
      where: {
        driver_id: driverId,
        status: status,
        createdAt: {
          [Op.gte]: startDate,
          [Op.lte]: endDate,
        }
      },
      include: [
        {
          model: User,
          as: 'merchant',
          attributes: ['username', 'shop_phone']
        }
      ],
      logging: (sql, timing) => {
        console.log("Executed SQL:", sql);
        if (timing) console.log("Execution time:", timing, "ms");
      }
    });

    res.send({
      success: true,
      data
    });

  } catch (err) {
    console.error("Error fetching deliveries:", err);
    res.status(500).send({
      success: false,
      message: err.message || "Some error occurred while retrieving deliveries."
    });
  }
};

exports.findDeliveryDone = (req, res) => {
  const driverId = req.params.id;

  // Calculate start and end of today (local time)
  const now = new Date();
  const startOfToday = new Date(now.setHours(0, 0, 0, 0));
  const endOfToday = new Date(now.setHours(23, 59, 59, 999));

  // Build where clause
  const whereClause = {
    driver_id: driverId,
    status: { [Op.in]: [3, 4, 5] },
    delivered_at: {
      [Op.between]: [startOfToday, endOfToday]
    }
  };

  Delivery.findAll({
    where: whereClause,
    order: [['delivered_at', 'DESC']],
  })
    .then(data => {
      res.send({
        success: true,
        data: data
      });
    })
    .catch(err => {
      res.status(500).send({
        message: err.message || "Some error occurred while retrieving deliveries."
      });
    });
};


exports.findUserDeliveries = (req, res) => {
    const userId = req.query.user_id;
    Delivery.findAll({ where: { driver_id: userId } })
        .then(data => res.send(data))
        .catch(err => res.status(500).send({ message: err.message }));
};


exports.findMerchantDelivery = (req, res) => {
  const userId = req.query.user_id;

  if (!userId) {
    return res.status(400).send({ success: false, message: "Missing user_id" });
  }

  // Current timestamp in Ulaanbaatar time
  const now = new Date();
  const ulaanbaatarOffset = 8 * 60; // +8 hours
  const localNow = new Date(now.getTime() + ulaanbaatarOffset * 60 * 1000);
  const sevenDaysAgo = new Date(localNow);
  sevenDaysAgo.setDate(localNow.getDate() - 7);

  Delivery.findAll({
    where: {
      merchant_id: userId,
      createdAt: {
        [Op.between]: [sevenDaysAgo, localNow],
      },
    },
    order: [["id", "DESC"]],
  })
    .then((data) => res.send({ success: true, data }))
    .catch((err) =>
      res
        .status(500)
        .send({ success: false, message: err.message || "Error fetching deliveries" })
    );
};
exports.findByDeliverId = async (req, res) => {
    const { deliveryId } = req.params;
  
    try {
      const delivery = await Delivery.findOne({
        where: { delivery_id: deliveryId },
        
      });
  
      if (!delivery) {
        return res.status(404).json({ message: "Delivery not found" });
      }
  
      res.json({ success: true, data: delivery });
    } catch (error) {
      console.error("Error fetching delivery by ID:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  };
  exports.getStatusCountsByDriver = async (req, res) => {
    const driverId = req.params.driver_id;
  
    const now = new Date();
    const startOfDay = new Date(now.setHours(0, 0, 0, 0));
    const endOfDay = new Date(now.setHours(23, 59, 59, 999));
  
    try {
      const statuses = await Status.findAll({
        attributes: [
          'id',
          'status',
          'color',
          [
            // Count matching deliveries for this status and driver for today
            literal(`(
              SELECT COUNT(*)
              FROM deliveries AS d
              WHERE d.status = status.id
                AND d.driver_id = ${driverId}
                AND d."createdAt" BETWEEN '${startOfDay.toISOString()}' AND '${endOfDay.toISOString()}'
            )`),
            'count'
          ]
        ],
        order: [['id', 'ASC']]
      });
  
      res.json(statuses);
    } catch (error) {
      console.error("Error fetching full status list with counts:", error);
      res.status(500).json({ error: "Server error", details: error.message });
    }
  };


exports.report = async (req, res) => {
  const { driver_id, start_date, end_date } = req.query;

  if (!start_date || !end_date) {
    return res.status(400).json({ success: false, message: 'start_date and end_date are required' });
  }

  try {
    // Build where clauses
    const driverFilter = driver_id ? { driver_id } : {};

    // 1️⃣ Total deliveries per local date based on createdAt
    const totalDeliveries = await Delivery.findAll({
      where: driverFilter,
      attributes: [
        [literal(`DATE("createdAt" AT TIME ZONE 'Asia/Ulaanbaatar')`), 'date'],
        [fn('COUNT', col('id')), 'total_deliveries'],
      ],
      having: literal(`DATE("createdAt" AT TIME ZONE 'Asia/Ulaanbaatar') BETWEEN '${start_date}' AND '${end_date}'`),
      group: [literal(`DATE("createdAt" AT TIME ZONE 'Asia/Ulaanbaatar')`)],
      raw: true,
    });

    // 2️⃣ Delivered stats per local date based on delivered_at
    const deliveredStats = await Delivery.findAll({
      where: {
        ...driverFilter,
        status: 3,
        delivered_at: { [Op.between]: [new Date(`${start_date}T00:00:00+08:00`), new Date(`${end_date}T23:59:59+08:00`)] },
      },
      attributes: [
        [fn('DATE', col('delivered_at')), 'date'],
        [fn('COUNT', col('id')), 'delivered_count'],
        [fn('SUM', col('price')), 'delivered_total_price'],
        [literal('COUNT(*) * 4000'), 'for_driver'],
        [literal('SUM(price) - (COUNT(*) * 4000)'), 'driver_margin'],
      ],
      group: [fn('DATE', col('delivered_at'))],
      raw: true,
    });

    // 3️⃣ Merge by date
    const resultMap = {};
    totalDeliveries.forEach(item => {
      resultMap[item.date] = { total_deliveries: parseInt(item.total_deliveries) };
    });
    deliveredStats.forEach(item => {
      if (!resultMap[item.date]) resultMap[item.date] = {};
      resultMap[item.date] = { ...resultMap[item.date], ...item };
    });

    // 4️⃣ Convert to array, sort DESC
    const finalData = Object.keys(resultMap)
      .sort((a, b) => new Date(b) - new Date(a))
      .map(date => ({
        date,
        total_deliveries: resultMap[date].total_deliveries || 0,
        delivered_count: resultMap[date].delivered_count || '0',
        delivered_total_price: resultMap[date].delivered_total_price || '0',
        for_driver: resultMap[date].for_driver || '0',
        driver_margin: resultMap[date].driver_margin || '0',
      }));

    return res.json({ success: true, data: finalData });
  } catch (error) {
    console.error('Error generating delivery report:', error);
    return res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

exports.completeDelivery = async (req, res) => {
  const id = req.params.id;
  const { status, driver_comment } = req.body;

  if (!status) {
    return res.status(400).send({
      success: false,
      message: "Status is required.",
    });
  }

  const t = await db.sequelize.transaction();

  try {
    // 🔹 Find delivery
    const delivery = await Delivery.findByPk(id, { transaction: t });
    if (!delivery) {
      await t.rollback();
      return res.status(404).send({
        success: false,
        message: "Delivery not found.",
      });
    }

    // 🔹 Prepare update fields
    const updateData = {
      status: parseInt(status, 10),
      delivered_at: new Date(), // ✅ Always set delivered_at to current time
    };

    // ✅ Add driver comment if provided
    if (driver_comment !== undefined) {
      updateData.driver_comment = driver_comment;
    }

    // 🔹 Update delivery
    await delivery.update(updateData, { transaction: t });

    // ✅ If declined (status 5) or status 7, restore stock
    const statusNum = parseInt(status, 10);
    if (statusNum === 5 || statusNum === 7) {
      const items = await DeliveryItem.findAll({
        where: { delivery_id: id },
        transaction: t,
      });

      for (const item of items) {
        await Good.increment(
          { stock: item.quantity },
          { where: { id: item.good_id }, transaction: t }
        );
      }
    }

    // 🔹 Insert into histories
    await db.histories.create(
      {
        merchant_id: delivery.merchant_id,
        delivery_id: delivery.id,
        driver_id: delivery.driver_id,
        status: parseInt(status, 10),
      },
      { transaction: t }
    );

    await t.commit();

    res.send({
      success: true,
      data: { message: `Delivery status updated to ${status} and history recorded.` },
    });
  } catch (err) {
    await t.rollback();
    console.error("❌ Error in completeDelivery:", err);
    res.status(500).send({
      success: false,
      message: err.message || "Server error while updating delivery.",
    });
  }
};



 exports.getDeliveryStatusSummary = async (req, res) => {
  const driverId = req.query.driver_id;
  if (!driverId) {
    return res.status(400).json({ success: false, message: 'driver_id is required' });
  }

  const today = new Date();
  const startOfDay = new Date(today.setHours(0, 0, 0, 0));
  const endOfDay   = new Date(today.setHours(23, 59, 59, 999));

  try {
    // 1️⃣ get all statuses
    const statuses = await Status.findAll({
      attributes: ['id', 'status', 'color'],
      raw: true,
    });

    // 2️⃣ get deliveries where status = 3, filter by delivered_at today
    const deliveredCounts = await Delivery.findAll({
      where: {
        driver_id: driverId,
        status: 3,
        delivered_at: { [Op.between]: [startOfDay, endOfDay] },
      },
      attributes: [
        'status',
        [fn('COUNT', col('id')), 'count'],
      ],
      group: ['status'],
      raw: true,
    });

    // 3️⃣ get deliveries where status != 3, filter by updatedAt today
    const otherStatusCounts = await Delivery.findAll({
      where: {
        driver_id: driverId,
        status: { [Op.ne]: 3 },
        updatedAt: { [Op.between]: [startOfDay, endOfDay] },
      },
      attributes: [
        'status',
        [fn('COUNT', col('id')), 'count'],
      ],
      group: ['status'],
      raw: true,
    });

    // 4️⃣ merge counts from both queries into one map
    const countMap = {};

    deliveredCounts.forEach(d => {
      countMap[d.status] = parseInt(d.count, 10);
    });
    otherStatusCounts.forEach(d => {
      // If the status is already in countMap (delivered), add to it,
      // else set it freshly.
      countMap[d.status] = (countMap[d.status] ?? 0) + parseInt(d.count, 10);
    });

    // 5️⃣ combine with status list to ensure zero count statuses are included
    const result = statuses.map(s => ({
      id: s.id,
      status: s.status,
      color: s.color,
      count: countMap[s.id] ?? 0,
    }));

    res.json({ success: true, data: result });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};



  exports.getCounts = async (req, res) => {
    const driverId = req.query.merchant_id;
    if (!driverId) {
      return res.status(400).json({ success: false, message: 'driver_id is required' });
    }
  
    const today = new Date();
    const startOfDay = new Date(today.setHours(0, 0, 0, 0));
    const endOfDay   = new Date(today.setHours(23, 59, 59, 999));
  
    try {
      /* 1️⃣  all statuses */
      const statuses = await Status.findAll({
        attributes: ['id', 'status', 'color'],
        raw: true,
      });
  
      /* 2️⃣  deliveries grouped by status id, today only */
      const deliveries = await Delivery.findAll({
        where: {
          merchant_id: driverId,
          createdAt: { [Op.between]: [startOfDay, endOfDay] },
        },
        attributes: [
          'status',
          [fn('COUNT', col('id')), 'count'],
        ],
        group: ['status'],
        raw: true,
      });
  
      /* 3️⃣  map counts */
      const countMap = {};
      deliveries.forEach(d => {
        countMap[d.status] = parseInt(d.count, 10);
      });
  
      /* 4️⃣  merge with status list (so zero‑count statuses still appear) */
      const result = statuses.map(s => ({
        id:     s.id,
        status: s.status,
        color:  s.color,
        count:  countMap[s.id] ?? 0,
      }));
  
      res.json({ success: true, data: result });
    } catch (err) {
      console.error(err);
      res.status(500).json({ success: false, message: 'Internal server error' });
    }
  };

exports.findWithStatusCustomer = (req, res) => {
  const merchantId = parseInt(req.params.id, 10);
  const status = parseInt(req.params.status, 10);

  if (isNaN(status) || isNaN(merchantId)) {
    return res.status(400).send({ success: false, message: "Invalid merchant or status parameter" });
  }

  const startOfToday = new Date();
  startOfToday.setHours(0, 0, 0, 0);

  const endOfToday = new Date();
  endOfToday.setHours(23, 59, 59, 999);

  Delivery.findAll({
    where: {
      merchant_id: merchantId,
      status: status,
      createdAt: {
        [Op.between]: [startOfToday, endOfToday]
      }
    }
  })
  .then(data => {
    res.send({
      success: true,
      data: data
    });
  })
  .catch(err => {
    res.status(500).send({
      success: false,
      message: err.message || "Some error occurred while retrieving deliveries."
    });
  });
};