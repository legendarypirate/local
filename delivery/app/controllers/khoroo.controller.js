const db = require("../models");
const Khoroo = db.khoroos;
const Region = db.regions;
const Op = db.Sequelize.Op;

// Create and Save a new Khoroo
exports.create = async (req, res) => {
  if (!req.body.name || !req.body.region_id) {
    return res.status(400).json({
      success: false,
      message: "Name and region_id are required!"
    });
  }

  try {
    // Validate that the region_id exists in the regions table
    const region = await Region.findByPk(req.body.region_id);
    if (!region) {
      return res.status(400).json({
        success: false,
        message: `Region with id=${req.body.region_id} does not exist. Please ensure the region exists before creating a khoroo.`
      });
    }

    const newKhoroo = {
      name: req.body.name,
      region_id: req.body.region_id,
    };

    const data = await Khoroo.create(newKhoroo);
    res.json({ success: true, data: data });
  } catch (err) {
    // Check if it's a foreign key constraint error
    if (err.name === 'SequelizeForeignKeyConstraintError') {
      return res.status(400).json({
        success: false,
        message: `Foreign key constraint violation: Region with id=${req.body.region_id} does not exist in the regions table.`
      });
    }
    res.status(500).json({
      success: false,
      message: err.message || "Some error occurred while creating the Khoroo."
    });
  }
};

// Retrieve all Khoroos from the database
exports.findAll = async (req, res) => {
  const { region_id } = req.query;

  try {
    const where = {};
    if (region_id) {
      where.region_id = region_id;
    }

    const data = await Khoroo.findAll({
      where,
      include: [
        {
          model: db.regions,
          as: 'region',
          attributes: ['id', 'name']
        }
      ],
      order: [['name', 'ASC']]
    });

    res.json({
      success: true,
      data: data
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      message: err.message || "Some error occurred while retrieving Khoroos."
    });
  }
};

// Find a single Khoroo with an id
exports.findOne = async (req, res) => {
  const id = req.params.id;

  try {
    const data = await Khoroo.findByPk(id, {
      include: [
        {
          model: db.regions,
          as: 'region',
          attributes: ['id', 'name']
        }
      ]
    });

    if (data) {
      res.json({ success: true, data: data });
    } else {
      res.status(404).json({
        success: false,
        message: `Cannot find Khoroo with id=${id}.`
      });
    }
  } catch (err) {
    res.status(500).json({
      success: false,
      message: "Error retrieving Khoroo with id=" + id
    });
  }
};

// Update a Khoroo by the id in the request
exports.update = async (req, res) => {
  const id = req.params.id;

  try {
    // Validate that the region_id exists if it's being updated
    if (req.body.region_id) {
      const region = await Region.findByPk(req.body.region_id);
      if (!region) {
        return res.status(400).json({
          success: false,
          message: `Region with id=${req.body.region_id} does not exist. Please ensure the region exists before updating the khoroo.`
        });
      }
    }

    const updateData = {};
    if (req.body.name) updateData.name = req.body.name;
    if (req.body.region_id) updateData.region_id = req.body.region_id;

    const [num] = await Khoroo.update(updateData, {
      where: { id: id }
    });

    if (num === 1) {
      const updatedKhoroo = await Khoroo.findByPk(id);
      res.json({
        success: true,
        message: "Khoroo was updated successfully.",
        data: updatedKhoroo,
      });
    } else {
      res.status(404).json({
        success: false,
        message: `Cannot update Khoroo with id=${id}. Maybe Khoroo was not found!`
      });
    }
  } catch (err) {
    // Check if it's a foreign key constraint error
    if (err.name === 'SequelizeForeignKeyConstraintError') {
      return res.status(400).json({
        success: false,
        message: `Foreign key constraint violation: Region with id=${req.body.region_id} does not exist in the regions table.`
      });
    }
    res.status(500).json({
      success: false,
      message: "Error updating Khoroo with id=" + id,
      error: err.message,
    });
  }
};

// Delete a Khoroo with the specified id in the request
exports.delete = async (req, res) => {
  const id = req.params.id;

  try {
    const num = await Khoroo.destroy({
      where: { id: id }
    });

    if (num === 1) {
      res.json({ success: true, message: "Khoroo was deleted successfully!" });
    } else {
      res.status(404).json({
        success: false,
        message: `Cannot delete Khoroo with id=${id}. Maybe Khoroo was not found!`
      });
    }
  } catch (err) {
    res.status(500).json({
      success: false,
      message: "Could not delete Khoroo with id=" + id,
      error: err.message
    });
  }
};

