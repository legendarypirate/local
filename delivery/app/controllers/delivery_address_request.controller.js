const db = require("../models");
const Delivery = db.deliveries;
const DeliveryAddressRequest = db.delivery_address_requests;

exports.findAllForAdmin = async (req, res) => {
  try {
    const status = req.query.status || "pending";
    const where = status === "all" ? {} : { status };
    const rows = await DeliveryAddressRequest.findAll({
      where,
      order: [["createdAt", "DESC"]],
      include: [
        {
          model: Delivery,
          as: "delivery",
          attributes: ["id", "phone", "address", "status", "driver_id", "merchant_id"],
          include: [
            { model: db.users, as: "merchant", attributes: ["id", "username"] },
            { model: db.users, as: "driver", attributes: ["id", "username"] },
          ],
        },
        { model: db.users, as: "requester", attributes: ["id", "username"] },
        { model: db.users, as: "new_driver", attributes: ["id", "username"], required: false },
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
  const new_driver_id = parseInt(req.body.new_driver_id, 10);
  if (!id || !new_driver_id) {
    return res.status(400).json({ success: false, message: "new_driver_id required" });
  }
  const t = await db.sequelize.transaction();
  try {
    const addrReq = await DeliveryAddressRequest.findByPk(id, { transaction: t });
    if (!addrReq || addrReq.status !== "pending") {
      await t.rollback();
      return res.status(400).json({ success: false, message: "Хүсэлт олдсонгүй эсвэл боловсруулсан" });
    }
    const delivery = await Delivery.findByPk(addrReq.delivery_id, { transaction: t });
    if (!delivery) {
      await t.rollback();
      return res.status(404).json({ success: false, message: "Хүргэлт олдсонгүй" });
    }
    await delivery.update(
      {
        address: addrReq.new_address,
        driver_id: new_driver_id,
        status: 2,
      },
      { transaction: t }
    );
    await db.histories.create(
      {
        merchant_id: delivery.merchant_id,
        delivery_id: delivery.id,
        driver_id: new_driver_id,
        status: 2,
      },
      { transaction: t }
    );
    await addrReq.update(
      {
        status: "approved",
        new_driver_id,
      },
      { transaction: t }
    );
    await t.commit();
    res.json({ success: true, message: "Зөвшөөрөгдлөө" });
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
    const reqRow = await DeliveryAddressRequest.findByPk(id);
    if (!reqRow || reqRow.status !== "pending") {
      return res.status(400).json({ success: false, message: "Хүсэлт олдсонгүй эсвэл боловсруулсан" });
    }
    await reqRow.update({ status: "rejected", admin_note });
    res.json({ success: true, message: "Татгалзлаа" });
  } catch (e) {
    console.error(e);
    res.status(500).json({ success: false, message: e.message || "Server error" });
  }
};
