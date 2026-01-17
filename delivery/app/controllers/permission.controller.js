const db = require("../models");
const Permission = db.permissions;  // make sure your model is named 'permission'

// Create and Save a new Permission
exports.create = async (req, res) => {
  if (!req.body.name) {
    return res.status(400).send({ message: "Permission name can not be empty!" });
  }

  try {
    const permission = await Permission.create({
      name: req.body.name,
      description: req.body.description || null,
      category: req.body.category || null,
    });
    res.send(permission);
  } catch (err) {
    res.status(500).send({
      message: err.message || "Some error occurred while creating the permission."
    });
  }
};

// Retrieve all Permissions from the database
exports.findAll = async (req, res) => {
    const name = req.query.name;
    var condition = name ? { name: { [Op.like]: `%${name}%` } } : null;
  
    try {
        console.log("ss");    
      const data = await Permission.findAll({ where: condition });
      console.log(data);
  
      res.send({
        success: true,
        data: data
      });
    } catch (err) {
      res.status(500).send({
        success: false,
        message: err.message || "Some error occurred while retrieving Categories."
      });
    }
  };
  
  
// Find a single Permission by id
exports.findOne = async (req, res) => {
  const id = req.params.id;

  try {
    const permission = await Permission.findByPk(id);
    if (permission) {
      res.send(permission);
    } else {
      res.status(404).send({ message: `Cannot find Permission with id=${id}.` });
    }
  } catch (err) {
    res.status(500).send({
      message: "Error retrieving Permission with id=" + id
    });
  }
};

// Update a Permission by the id in the request
exports.update = async (req, res) => {
  const id = req.params.id;

  try {
    const num = await Permission.update(req.body, {
      where: { id: id }
    });

    if (num == 1) {
      res.send({ message: "Permission was updated successfully." });
    } else {
      res.send({
        message: `Cannot update Permission with id=${id}. Maybe Permission was not found or req.body is empty!`
      });
    }
  } catch (err) {
    res.status(500).send({
      message: "Error updating Permission with id=" + id
    });
  }
};

// Delete a Permission with the specified id in the request
exports.delete = async (req, res) => {
  const id = req.params.id;

  try {
    const num = await Permission.destroy({
      where: { id: id }
    });

    if (num == 1) {
      res.send({ message: "Permission was deleted successfully!" });
    } else {
      res.send({
        message: `Cannot delete Permission with id=${id}. Maybe Permission was not found!`
      });
    }
  } catch (err) {
    res.status(500).send({
      message: "Could not delete Permission with id=" + id
    });
  }
};

// Delete all Permissions from the database.
exports.deleteAll = async (req, res) => {
  try {
    const nums = await Permission.destroy({
      where: {},
      truncate: false
    });
    res.send({ message: `${nums} Permissions were deleted successfully!` });
  } catch (err) {
    res.status(500).send({
      message: err.message || "Some error occurred while removing all permissions."
    });
  }
};
