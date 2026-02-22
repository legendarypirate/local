const db = require("../models");
const Summary = db.summaries;
const Op = db.Sequelize.Op;
const User = db.users;

// Create a new Summary
exports.create = async (req, res) => {
  try {
    const data = {
      driver_id: req.body.driver_id,
      total: req.body.total,
      driver: req.body.driver,
      account: req.body.account,
      comment: req.body.comment || '',
      merchant_id: req.body.merchant_id,
      number_delivery: req.body.number_delivery || 0
    };

    const summary = await Summary.create(data);
    res.status(201).json(summary);
  } catch (err) {
    console.error("Error creating summary:", err);
    res.status(500).json({ message: err.message || "Some error occurred while creating the Summary." });
  }
};

// Retrieve all Summaries
exports.findAll = async (req, res) => {
  const rawUserId = req.query.user_id;
  const userId = rawUserId != null && rawUserId !== '' ? parseInt(rawUserId, 10) : null;
  const { startDate, endDate } = req.query;

  let where = {};

  if (userId != null && !Number.isNaN(userId)) {
    where[Op.or] = [
      { driver_id: userId },
      { merchant_id: userId }
    ];
  }

  if (startDate && endDate) {
    where.createdAt = {
      [Op.gte]: new Date(startDate + 'T00:00:00'),
      [Op.lte]: new Date(endDate + 'T23:59:59'),
    };
  }

  try {
    const data = await Summary.findAll({
      where,
      include: [
        {
          model: User,
          as: 'driver_summaries',
          attributes: ['id', 'username']
        },
        {
          model: User,
          as: 'merchant',
          attributes: ['id', 'username']
        }
      ],
      order: [['id', 'DESC']]
    });

    res.send({ success: true, data });
  } catch (err) {
    console.error("Error fetching summaries:", err);
    res.status(500).send({
      success: false,
      message: err.message || "Some error occurred while retrieving summaries."
    });
  }
};

// Find one Summary by ID
exports.findOne = async (req, res) => {
  const id = req.params.id;

  try {
    const summary = await Summary.findByPk(id);

    if (!summary) {
      return res.status(404).json({ message: `Cannot find Summary with id=${id}.` });
    }

    res.json(summary);
  } catch (err) {
    console.error("Error retrieving summary:", err);
    res.status(500).json({ message: "Error retrieving Summary with id=" + id });
  }
};

// Update a Summary by ID
exports.update = async (req, res) => {
  const id = req.params.id;

  try {
    const [num] = await Summary.update(req.body, {
      where: { id: id }
    });

    if (num === 1) {
      res.json({ message: "Summary was updated successfully." });
    } else {
      res.status(404).json({ message: `Cannot update Summary with id=${id}. Maybe Summary was not found or req.body is empty!` });
    }
  } catch (err) {
    console.error("Error updating summary:", err);
    res.status(500).json({ message: "Error updating Summary with id=" + id });
  }
};

// Delete a Summary by ID
exports.delete = async (req, res) => {
  const id = req.params.id;

  try {
    const num = await Summary.destroy({
      where: { id: id }
    });

    if (num === 1) {
      res.json({ message: "Summary was deleted successfully!" });
    } else {
      res.status(404).json({ message: `Cannot delete Summary with id=${id}. Maybe Summary was not found!` });
    }
  } catch (err) {
    console.error("Error deleting summary:", err);
    res.status(500).json({ message: "Could not delete Summary with id=" + id });
  }
};

// Delete all Summaries
exports.deleteAll = async (req, res) => {
  try {
    const nums = await Summary.destroy({
      where: {},
      truncate: false
    });
    res.json({ message: `${nums} Summaries were deleted successfully!` });
  } catch (err) {
    console.error("Error deleting all summaries:", err);
    res.status(500).json({ message: err.message || "Some error occurred while removing all summaries." });
  }
};
