const db = require("../models");
const Delivery = db.deliveries;
const DeliveryNotPickedRequest = db.delivery_not_picked_requests;

exports.findAllForAdmin = async (req, res) => {
  try {
    const status = req.query.status || "pending";
    const where = status === "all" ? {} : { status };
    const rows = await DeliveryNotPickedRequest.findAll({
      where,
      order: [["createdAt", "DESC"]],
      include: [
        {
          model: Delivery,
          as: "delivery",
          attributes: ["id", "phone", "address", "status", "driver_id", "merchant_id", "delivery_id"],
          include: [
            { model: db.users, as: "merchant", attributes: ["id", "username"] },
            { model: db.users, as: "driver", attributes: ["id", "username"] },
          ],
        },
        { model: db.users, as: "requester", attributes: ["id", "username"] },
      ],
    });
    res.json({ success: true, data: rows });
  } catch (e) {
    console.error(e);
    res.status(500).json({ success: false, message: e.message || "Server error" });
  }
};

exports.approve = async (req, res) => {
  const id = parseInt(req.params.id, 10);
  if (!id) {
    return res.status(400).json({ success: false, message: "Invalid id" });
  }
  const t = await db.sequelize.transaction();
  try {
    const reqRow = await DeliveryNotPickedRequest.findByPk(id, { transaction: t });
    if (!reqRow || reqRow.status !== "pending") {
      await t.rollback();
      return res.status(400).json({ success: false, message: "Хүсэлт олдсонгүй эсвэл боловсруулсан" });
    }
    const delivery = await Delivery.findByPk(reqRow.delivery_id, { transaction: t });
    if (!delivery) {
      await t.rollback();
      return res.status(404).json({ success: false, message: "Хүргэлт олдсонгүй" });
    }
    if (delivery.status !== 2) {
      await t.rollback();
      return res.status(400).json({
        success: false,
        message: "Хүргэлт одоо жолоочийн гарт биш (төлөв 2 биш). Зөвшөөрөх боломжгүй.",
      });
    }

    const updatePayload = { status: 10 };
    if (reqRow.driver_comment) {
      updatePayload.driver_comment = reqRow.driver_comment;
    }
    await delivery.update(updatePayload, { transaction: t });

    await db.histories.create(
      {
        merchant_id: delivery.merchant_id,
        delivery_id: delivery.id,
        driver_id: delivery.driver_id,
        status: 10,
      },
      { transaction: t }
    );

    await reqRow.update({ status: "approved" }, { transaction: t });
    await t.commit();
    res.json({ success: true, message: "Зөвшөөрөгдлөө — төлөв 10 боллоо" });
  } catch (e) {
    await t.rollback();
    console.error(e);
    res.status(500).json({ success: false, message: e.message || "Server error" });
  }
};

exports.reject = async (req, res) => {
  const id = parseInt(req.params.id, 10);
  const admin_note = req.body.admin_note || null;
  try {
    const reqRow = await DeliveryNotPickedRequest.findByPk(id);
    if (!reqRow || reqRow.status !== "pending") {
      return res.status(400).json({ success: false, message: "Хүсэлт олдсонгүй эсвэл боловсруулсан" });
    }
    await reqRow.update({ status: "rejected", admin_note });
    res.json({ success: true, message: "Татгалзлаа — хүргэлт төлөв 2 хэвээр" });
  } catch (e) {
    console.error(e);
    res.status(500).json({ success: false, message: e.message || "Server error" });
  }
};
