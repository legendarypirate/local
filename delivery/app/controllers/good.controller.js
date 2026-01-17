const db = require("../models");
const Good = db.goods;
const Op = db.Sequelize.Op;
const User = db.users;
const Ware = db.wares;

// Create and Save a new Categories
exports.create = (req, res) => {
  // Validate request
  if (!req.body.name) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
    return;
  }

  // Create a Categories
  const good = {
    name: req.body.name,
    ware_id:req.body.ware_id,
    merchant_id:req.body.merchant_id,
    stock:req.body.stock
  };

  // Save Categories in the database
  Good.create(good)
  .then(data => {
    res.json({ success: true, data: data });
  })
  .catch(err => {
    res.status(500).json({ success: false, message: err.message || "Some error occurred while creating the Banner." });
  });
};

// Retrieve all Categories from the database.

exports.findAll = async (req, res) => {
  const merchant_id = req.query.merchant_id;

  // Build condition only if merchant_id exists, exact match assumed
  const condition = merchant_id ? { merchant_id: merchant_id } : undefined;

  try {
    const data = await Good.findAll({
      where: condition,
      include: [
        {
          model: User,
          as: 'merchant',
          attributes: ['id', 'username'], // select fields needed
        },
        {
          model: Ware,
          as: 'ware',
          attributes: ['id', 'name'],
        },
      ],
    });

    res.send({
      success: true,
      data,
    });
  } catch (err) {
    res.status(500).send({
      success: false,
      message: err.message || "Some error occurred while retrieving goods.",
    });
  }
};

  // Update stock only, add or deduct based on type
exports.updateStock = async (req, res) => {
  const id = req.params.id;
  const { type, amount } = req.body;  // expect type: 1 or 2, quantity: number

  if (typeof type !== 'number' || (type !== 1 && type !== 2)) {
    return res.status(400).send({ message: "Invalid or missing 'type'. Must be 1 (Orlogo) or 2 (Zarlaga)." });
  }
  if (typeof amount !== 'number' || amount <= 0) {
    return res.status(400).send({ message: "Invalid or missing 'quantity'. Must be a positive number." });
  }

  try {
    const good = await Good.findByPk(id);  // adjust to your ORM
    if (!good) {
      return res.status(404).send({ message: `Good with id=${id} not found.` });
    }

    if (type === 1) {
      // Orlogo: add quantity
      good.stock += amount;
    } else if (type === 2) {
      // Zarlaga: deduct quantity, but prevent negative stock
      // if (good.stock < amount) {
      //   return res.status(400).send({ message: "Insufficient stock to deduct." });
      // }
      good.stock -= amount;
    }

    await good.save();

    res.send({ success: true, message: "Stock updated successfully.", data: good });
  } catch (error) {
    console.error(error);
    res.status(500).send({ message: "Error updating stock.", error });
  }
};

// Find a single Categories with an id
exports.findOne = (req, res) => {
  const id = req.params.id;

  category.findByPk(id)
    .then(data => {
      if (data) {
        res.send(data);
      } else {
        res.status(404).send({
          message: `Cannot find category with id=${id}.`
        });
      }
    })
    .catch(err => {
      res.status(500).send({
        message: "Error retrieving category with id=" + id
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

  Good.destroy({
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
