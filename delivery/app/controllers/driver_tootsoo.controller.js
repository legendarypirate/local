const db = require("../models");
const DriverTootsoo = db.driver_tootsoos;
const Op = db.Sequelize.Op;

exports.findAll = async (req, res) => {
  try {
    const { driver_id, from_date, to_date } = req.query;
    const where = {};

    if (driver_id != null && driver_id !== "") {
      const id = parseInt(driver_id, 10);
      if (!Number.isNaN(id)) where.driver_id = id;
    }

    if (from_date && to_date) {
      where[Op.and] = [
        db.sequelize.where(
          db.sequelize.col("start_date"),
          { [Op.lte]: to_date }
        ),
        db.sequelize.where(
          db.sequelize.col("end_date"),
          { [Op.gte]: from_date }
        ),
      ];
    }

    const data = await DriverTootsoo.findAll({
      where: Object.keys(where).length ? where : undefined,
      order: [["createdAt", "DESC"]],
      include: [{ model: db.users, as: "driver", attributes: ["id", "username"] }],
    });
    res.json({ success: true, data });
  } catch (err) {
    console.error("Error listing driver_tootsoos:", err);
    res.status(500).json({
      success: false,
      message: err.message || "Error retrieving driver tootsoos.",
    });
  }
};

exports.create = async (req, res) => {
  try {
    const record = await DriverTootsoo.create({
      driver_id: req.body.driver_id,
      start_date: req.body.start_date,
      end_date: req.body.end_date,
      total_price: req.body.total_price ?? 0,
      for_driver: req.body.for_driver ?? 0,
      extra_deduction: req.body.extra_deduction ?? 0,
      account: req.body.account ?? 0,
      number_delivery: req.body.number_delivery ?? 0,
      delivery_ids: req.body.delivery_ids || [],
      status: req.body.status ?? 1,
    });
    res.status(201).json({ success: true, data: record });
  } catch (err) {
    console.error("Error creating driver_tootsoo:", err);
    res.status(500).json({
      success: false,
      message: err.message || "Error creating driver tootsoo.",
    });
  }
};

exports.updateStatus = async (req, res) => {
  const id = parseInt(req.params.id, 10);
  const { status } = req.body;
  if (Number.isNaN(id) || (status !== 1 && status !== 2)) {
    return res.status(400).json({
      success: false,
      message: "Valid id and status (1 or 2) required.",
    });
  }
  try {
    const record = await DriverTootsoo.findByPk(id);
    if (!record) {
      return res.status(404).json({ success: false, message: "Record not found." });
    }
    await record.update({ status });
    res.json({ success: true, data: record });
  } catch (err) {
    console.error("Error updating driver_tootsoo status:", err);
    res.status(500).json({
      success: false,
      message: err.message || "Error updating status.",
    });
  }
};
