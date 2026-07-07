const db = require("../models");
const Delivery = db.deliveries;
const DeliveryNotPickedRequest = db.delivery_not_picked_requests;

const TERMINAL_DELIVERY_STATUSES = new Set([3, 5]);

async function findPendingNotPicked(deliveryId, transaction) {
  return DeliveryNotPickedRequest.findOne({
    where: { delivery_id: deliveryId, status: "pending" },
    transaction,
  });
}

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
    const reqRow = await DeliveryNotPickedRequest.findByPk(id, {
      transaction: t,
      lock: t.LOCK.UPDATE,
    });
    if (!reqRow || reqRow.status !== "pending") {
      await t.rollback();
      return res.status(400).json({ success: false, message: "Хүсэлт олдсонгүй эсвэл боловсруулсан" });
    }
    const delivery = await Delivery.findByPk(reqRow.delivery_id, {
      transaction: t,
      lock: t.LOCK.UPDATE,
    });
    if (!delivery) {
      await t.rollback();
      return res.status(404).json({ success: false, message: "Хүргэлт олдсонгүй" });
    }
    if (delivery.is_deleted) {
      await t.rollback();
      return res.status(400).json({ success: false, message: "Хүргэлт устгагдсан" });
    }

    const deliveryStatus = Number(delivery.status);
    if (deliveryStatus === 10) {
      await reqRow.update({ status: "approved" }, { transaction: t });
      await t.commit();
      return res.json({ success: true, message: "Хүсэлт аль хэдийн зөвшөөрөгдсөн (төлөв 10)" });
    }
    if (TERMINAL_DELIVERY_STATUSES.has(deliveryStatus)) {
      await t.rollback();
      return res.status(400).json({
        success: false,
        message: `Хүргэлтийн төлөв ${deliveryStatus} — зөвшөөрөх боломжгүй.`,
      });
    }

    const updatePayload = { status: 10, delivered_at: new Date() };
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
  if (!id) {
    return res.status(400).json({ success: false, message: "Invalid id" });
  }
  const t = await db.sequelize.transaction();
  try {
    const reqRow = await DeliveryNotPickedRequest.findByPk(id, {
      transaction: t,
      lock: t.LOCK.UPDATE,
    });
    if (!reqRow || reqRow.status !== "pending") {
      await t.rollback();
      return res.status(400).json({ success: false, message: "Хүсэлт олдсонгүй эсвэл боловсруулсан" });
    }
    const delivery = await Delivery.findByPk(reqRow.delivery_id, { transaction: t });
    if (!delivery) {
      await t.rollback();
      return res.status(404).json({ success: false, message: "Хүргэлт олдсонгүй" });
    }

    await reqRow.update({ status: "rejected", admin_note }, { transaction: t });

    // Keep delivery on driver list (status 2) after rejection
    if (Number(delivery.status) !== 2) {
      await delivery.update({ status: 2 }, { transaction: t });
    }

    await t.commit();
    res.json({
      success: true,
      message: "Татгалзлаа — хүргэлт жолоочийн жагсаалтад хэвээр үлдэнэ",
    });
  } catch (e) {
    await t.rollback();
    console.error(e);
    res.status(500).json({ success: false, message: e.message || "Server error" });
  }
};
