const db = require("../models");
const User = db.users;
const Delivery = db.deliveries;
const Op = db.Sequelize.Op;
const sequelize = db.sequelize;
const bcrypt = require('bcryptjs');
const saltRounds = 10; // Number of salt rounds for bcrypt

// Create and Save a new User
exports.create = async (req, res) => {
  // Validate request
  if (!req.body.username || !req.body.role_id || !req.body.password) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
    return;
  }

  try {
    // Hash the password
    const hashedPassword = await bcrypt.hash(req.body.password, saltRounds);

    // Create a User object
    const user = {
      username: req.body.username,
      phone: req.body.phone,
      email: req.body.email,
      shop_phone: req.body.shop_phone,
      contact_info: req.body.contact_info,
      role_id: req.body.role_id,
      password: hashedPassword,
      account_number: req.body.account_number,
      facebook_name: req.body.facebook_name
    };

    // Save User in the database
    const data = await User.create(user);
    res.send(data);
  } catch (err) {
    res.status(500).send({
      message: err.message || "Some error occurred while creating the User."
    });
  }
};

exports.findMerchants = (req, res) => {
  User.findAll({ where: { role_id: 2 } }) // Adjust the role_id if needed
    .then(data => {
      res.send({ success: true, data });
    })
    .catch(err => {
      res.status(500).send({
        message: err.message || "Some error occurred while retrieving merchants."
      });
    });
};

exports.findDrivers = async (req, res) => {
  try {
    const drivers = await User.findAll({
      where: { role_id: 3 }, // adjust if column name is different
      attributes: ['id', 'username'] // select only needed fields
    });

    res.send({
      success: true,
      data: drivers
    });
  } catch (err) {
    res.status(500).send({
      success: false,
      message: err.message || "Some error occurred while retrieving drivers."
    });
  }
};

/**
 * Get all drivers with count of deliveries where status = 2 (driver is carrying).
 */
exports.findDriversWithDeliveryCount = async (req, res) => {
  try {
    const drivers = await User.findAll({
      where: { role_id: 3 },
      attributes: ['id', 'username']
    });

    const countByDriver = await sequelize.query(
      `SELECT driver_id, COUNT(*) as count FROM deliveries WHERE status = 2 AND driver_id IS NOT NULL GROUP BY driver_id`,
      { type: sequelize.QueryTypes.SELECT }
    );
    const countMap = {};
    (countByDriver || []).forEach((row) => {
      if (row && row.driver_id != null) countMap[row.driver_id] = parseInt(row.count, 10) || 0;
    });

    const data = drivers.map((d) => ({
      id: d.id,
      username: d.username,
      deliveryCountStatus2: countMap[d.id] || 0
    }));

    res.send({ success: true, data });
  } catch (err) {
    res.status(500).send({
      success: false,
      message: err.message || "Some error occurred while retrieving drivers with delivery count."
    });
  }
};
exports.findAll = async (req, res) => {
  const username = req.query.username;

  // Build dynamic condition object
  const condition = {
    role_id: { [Op.ne]: 1 } // Exclude users with role_id === 1
  };

  if (username) {
    condition.username = { [Op.like]: `%${username}%` };
  }

  try {
    const data = await User.findAll({ where: condition });

    res.send({
      success: true,
      data: data
    });
  } catch (err) {
    res.status(500).send({
      success: false,
      message: err.message || "Some error occurred while retrieving users."
    });
  }
};

// Find a single User with an id
exports.findOne = (req, res) => {
  const id = req.params.id;

  User.findByPk(id)
    .then(data => {
      if (data) {
        res.send({
          success: true,  // ← boolean true, not "true"
          data: data
        });
      } else {
        res.status(404).send({
          success: false,  // ← boolean false, not "false"
          message: `Cannot find User with id=${id}.`
        });
      }
    })
    .catch(err => {
      res.status(500).send({
        success: false,  // ← boolean false, not "false"
        message: "Error retrieving User with id=" + id
      });
    });
};

// Update a User by the id in the request
exports.update = (req, res) => {
  const id = req.params.id;

  User.update(req.body, {
    where: { id: id }
  })
    .then(num => {
      if (num == 1) {
        // Fetch and return the updated user data
        User.findByPk(id)
          .then(data => {
            res.send({
              success: true,
              data: data,
              message: "User was updated successfully."
            });
          })
          .catch(err => {
            res.status(500).send({
              success: false,
              message: "Error fetching updated user data: " + err
            });
          });
      } else {
        res.status(404).send({
          success: false,
          message: `Cannot update User with id=${id}. Maybe User was not found or req.body is empty!`
        });
      }
    })
    .catch(err => {
      res.status(500).send({
        success: false,
        message: "Error updating User with id=" + id
      });
    });
};
// Delete a User with the specified id in the request
exports.delete = (req, res) => {
  const id = req.params.id;

  User.destroy({ where: { id: id } })
    .then(num => {
      if (num === 1) {
        res.json({
          success: true,
          message: "User was deleted successfully!"
        });
      } else {
        res.status(404).json({
          success: false,
          message: `Cannot delete User with id=${id}. Maybe User was not found!`
        });
      }
    })
    .catch(err => {
      res.status(500).json({
        success: false,
        message: "Could not delete User with id=" + id
      });
    });
};


// Delete all User from the database.
exports.deleteAll = (req, res) => {
  User.destroy({
    where: {},
    truncate: false
  })
    .then(nums => {
      res.send({ message: `${nums} User were deleted successfully!` });
    })
    .catch(err => {
      res.status(500).send({
        message:
          err.message || "Some error occurred while removing all User."
      });
    });
};

// find all published User
exports.findAllPublished = (req, res) => {
  User.findAll({ where: { published: true } })
    .then(data => {
      res.send(data);
    })
    .catch(err => {
      res.status(500).send({
        message:
          err.message || "Some error occurred while retrieving User."
      });
    });
};
