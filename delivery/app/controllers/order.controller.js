const db = require("../models");
const Order = db.orders;
const Op = db.Sequelize.Op;
const User = db.users;
const Status = db.statuses;

// Create and Save a new Categories
exports.create = (req, res) => {
  // Validate request
  if (!req.body.merchant_id || !req.body.phone || !req.body.address || !req.body.comment) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
    return;
  }

  // Create a Categories
  const newOrder = {
    merchant_id: req.body.merchant_id,
    phone: req.body.phone,
    address: req.body.address,
    status: 1,
    comment: req.body.comment
  };

  // Save Categories in the database
  Order.create(newOrder)
  .then(data => {
    res.json({ success: true, data: data });
  })
  .catch(err => {
    res.status(500).json({ success: false, message: err.message || "Some error occurred while creating the Banner." });
  });
};

exports.allocateDeliveries = async (req, res) => {
    const { driver_id, delivery_ids } = req.body;
  
    if (!driver_id || !Array.isArray(delivery_ids) || delivery_ids.length === 0) {
      return res.status(400).json({
        success: false,
        message: "Driver ID and a list of delivery IDs are required.",
      });
    }
  
    try {
      // Bulk update the deliveries
      await Order.update(
        {
          driver_id,     // Assign the driver ID
          status: 2,      // Set the status to 2 (or any value that represents the allocated state)
        },
        {
          where: {
            id: delivery_ids, // Filter by the selected delivery IDs
          },
        }
      );
  
      res.json({
        success: true,
        message: "Orders allocated and status updated successfully.",
      });
    } catch (error) {
      console.error("Error allocating orders:", error);
      res.status(500).json({
        success: false,
        message: "Server error while allocating orders.",
      });
    }
  };
  //80989497

  exports.findAll = async (req, res) => {
    const { merchant_id, phone, start_date, end_date } = req.query;
    const statusIds = req.query.status_ids ? req.query.status_ids.split(',').map(Number) : [];
  
    // Build dynamic filter condition
    const condition = {};
  
    if (merchant_id) {
      condition.merchant_id = merchant_id;
    }
  
    if (statusIds.length > 0) {
      condition.status = { [Op.in]: statusIds };
    }
  
    if (phone) {
      condition.phone = { [Op.like]: `%${phone}%` };
    }
  
    if (start_date && end_date) {
      condition.createdAt = {
        [Op.between]: [new Date(start_date), new Date(end_date)],
      };
    } else if (start_date) {
      condition.createdAt = {
        [Op.gte]: new Date(start_date),
      };
    } else if (end_date) {
      condition.createdAt = {
        [Op.lte]: new Date(end_date),
      };
    }
  
    try {
      const page = parseInt(req.query.page) || 1;
      const limit = parseInt(req.query.limit) || 10;
      const offset = (page - 1) * limit;
  
      const { count, rows } = await Order.findAndCountAll({
        where: condition,
        limit,
        offset,
        include: [
          {
            model: User,
            as: 'merchant',
            attributes: ['username'],
          },
          {
            model: User,
            as: 'driver',
            attributes: ['username'],
          },
        ],
        order: [['id', 'DESC']],
      });
  
      const formattedDeliveries = rows.map(delivery => delivery.toJSON());
  
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
      console.error(error);
      res.status(500).json({ success: false, message: 'Server error' });
    }
  };
  
  exports.findOne = (req, res) => {
    const id = req.params.id;
  
    Order.findByPk(id, {
      include: [{
        model: User,
        as: 'merchant',  // Make sure your Order model has a merchant association defined
        attributes: ['username']
      }]
    })
    .then(data => {
      if (data) {
        // Add custom status text
        const result = {
          ...data.toJSON(),
          status_text: 'Хуваарилсан'  // Your fixed status text
        };
        res.send({
          success: true,
          data: result
        });
      } else {
        res.status(404).send({
          success: false,
          message: `Cannot find order with id=${id}.`
        });
      }
    })
    .catch(err => {
      res.status(500).send({
        success: false,
        message: "Error retrieving order with id=" + id
      });
    });
  };

// Update a Categories by the id in the request
exports.update = (req, res) => {
  const id = req.params.id;

  // Validate request (ensure at least one field is provided)
  if (!req.body.brand && !req.body.nature) {
    return res.status(400).json({
      success: false,
      message: "Request body cannot be empty. At least brand or nature is required.",
    });
  }

  // Prepare the data for updating
  const updateData = {
    brand: req.body.brand || null,
    nature: req.body.nature || null,
  };

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
exports.delete = (req, res) => {
  const id = req.params.id;

  category.destroy({
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

// Delete all Tutorials from the database.
exports.deleteAll = (req, res) => {
  category.destroy({
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
