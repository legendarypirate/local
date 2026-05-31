const db = require('../models');
const DeliveryPriceSetting = db.delivery_price_settings;
const Delivery = db.deliveries;

async function clearOtherDefaults(excludeId, transaction) {
  await DeliveryPriceSetting.update(
    { is_default: false },
    {
      where: excludeId ? { id: { [db.Sequelize.Op.ne]: excludeId } } : {},
      transaction,
    }
  );
}

exports.findAll = async (req, res) => {
  try {
    const rows = await DeliveryPriceSetting.findAll({
      order: [
        ['is_default', 'DESC'],
        ['id', 'ASC'],
      ],
    });
    res.json({ success: true, data: rows });
  } catch (e) {
    console.error(e);
    res.status(500).json({ success: false, message: e.message || 'Server error' });
  }
};

exports.create = async (req, res) => {
  const merchant_price = parseInt(req.body.merchant_price, 10);
  const driver_price = parseInt(req.body.driver_price, 10);
  const label = req.body.label?.trim() || null;
  const is_default = !!req.body.is_default;

  if (Number.isNaN(merchant_price) || merchant_price < 0 || Number.isNaN(driver_price) || driver_price < 0) {
    return res.status(400).json({ success: false, message: 'merchant_price and driver_price are required.' });
  }

  const t = await db.sequelize.transaction();
  try {
    if (is_default) await clearOtherDefaults(null, t);
    const row = await DeliveryPriceSetting.create(
      { label, merchant_price, driver_price, is_default },
      { transaction: t }
    );
    await t.commit();
    res.status(201).json({ success: true, data: row });
  } catch (e) {
    await t.rollback();
    console.error(e);
    res.status(500).json({ success: false, message: e.message || 'Server error' });
  }
};

exports.update = async (req, res) => {
  const id = parseInt(req.params.id, 10);
  if (!id) return res.status(400).json({ success: false, message: 'Invalid id' });

  const row = await DeliveryPriceSetting.findByPk(id);
  if (!row) return res.status(404).json({ success: false, message: 'Not found' });

  const update = {};
  if (req.body.label !== undefined) update.label = req.body.label?.trim() || null;
  if (req.body.merchant_price !== undefined) {
    const n = parseInt(req.body.merchant_price, 10);
    if (Number.isNaN(n) || n < 0) {
      return res.status(400).json({ success: false, message: 'Invalid merchant_price' });
    }
    update.merchant_price = n;
  }
  if (req.body.driver_price !== undefined) {
    const n = parseInt(req.body.driver_price, 10);
    if (Number.isNaN(n) || n < 0) {
      return res.status(400).json({ success: false, message: 'Invalid driver_price' });
    }
    update.driver_price = n;
  }
  if (req.body.is_default !== undefined) update.is_default = !!req.body.is_default;

  const t = await db.sequelize.transaction();
  try {
    if (update.is_default) await clearOtherDefaults(id, t);
    await row.update(update, { transaction: t });
    if (update.merchant_price !== undefined) {
      await Delivery.update(
        { delivery_price: update.merchant_price },
        { where: { price_setting_id: id }, transaction: t }
      );
    }
    await t.commit();
    const fresh = await DeliveryPriceSetting.findByPk(id);
    res.json({ success: true, data: fresh });
  } catch (e) {
    await t.rollback();
    console.error(e);
    res.status(500).json({ success: false, message: e.message || 'Server error' });
  }
};

exports.remove = async (req, res) => {
  const id = parseInt(req.params.id, 10);
  if (!id) return res.status(400).json({ success: false, message: 'Invalid id' });

  const row = await DeliveryPriceSetting.findByPk(id);
  if (!row) return res.status(404).json({ success: false, message: 'Not found' });
  if (row.is_default) {
    return res.status(400).json({ success: false, message: 'Cannot delete the default price setting.' });
  }

  const inUse = await Delivery.count({ where: { price_setting_id: id } });
  if (inUse > 0) {
    return res.status(400).json({
      success: false,
      message: `This setting is used by ${inUse} delivery(ies). Reassign them first.`,
    });
  }

  try {
    await row.destroy();
    res.json({ success: true, message: 'Deleted' });
  } catch (e) {
    console.error(e);
    res.status(500).json({ success: false, message: e.message || 'Server error' });
  }
};

/** Used internally when creating deliveries */
exports.getDefaultSetting = async () => {
  let row = await DeliveryPriceSetting.findOne({ where: { is_default: true } });
  if (!row) {
    row = await DeliveryPriceSetting.findOne({ order: [['id', 'ASC']] });
  }
  return row;
};
