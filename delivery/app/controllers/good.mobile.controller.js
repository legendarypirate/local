const db = require("../models");
const Good = db.goods;
const Ware = db.wares;
const { uploadGoodImage } = require("../utils/cloudinary");

exports.findMerchantGood = async (req, res) => {
  const userId = parseInt(req.query.user_id, 10);

  if (!userId || Number.isNaN(userId)) {
    return res.status(400).send({ success: false, message: "Missing user_id" });
  }

  try {
    const data = await Good.findAll({
      where: { merchant_id: userId },
      include: [
        {
          model: Ware,
          as: "ware",
          attributes: ["id", "name"],
        },
      ],
      order: [["id", "DESC"]],
    });
    res.send({ success: true, data });
  } catch (err) {
    res.status(500).send({ success: false, message: err.message });
  }
};

exports.uploadGoodImage = async (req, res) => {
  const id = parseInt(req.params.id, 10);
  const merchantId = parseInt(req.body.merchant_user_id, 10);

  if (!id || Number.isNaN(id)) {
    return res.status(400).json({ success: false, message: "Invalid good id" });
  }
  if (!merchantId || Number.isNaN(merchantId)) {
    return res.status(400).json({ success: false, message: "merchant_user_id required" });
  }
  if (!req.file) {
    return res.status(400).json({ success: false, message: "image file required" });
  }

  try {
    const good = await Good.findByPk(id);
    if (!good) {
      return res.status(404).json({ success: false, message: "Good not found" });
    }
    if (Number(good.merchant_id) !== merchantId) {
      return res.status(403).json({ success: false, message: "Not your good" });
    }

    const imageUrl = await uploadGoodImage(req.file);
    good.image_url = imageUrl;
    await good.save();

    const full = await Good.findByPk(id, {
      include: [{ model: Ware, as: "ware", attributes: ["id", "name"] }],
    });

    res.json({
      success: true,
      message: "Зураг хадгалагдлаа",
      data: full,
    });
  } catch (err) {
    console.error("uploadGoodImage:", err);
    res.status(500).json({
      success: false,
      message: err.message || "Image upload failed",
    });
  }
};
