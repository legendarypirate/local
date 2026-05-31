const db = require('../models');
const ServiceRegion = db.service_regions;
const ServiceRegionKhoroo = db.service_region_khoroos;
const Khoroo = db.khoroos;
const Region = db.regions;
const User = db.users;

async function ensureRuralDefault() {
  await ServiceRegion.findOrCreate({
    where: { is_rural: true },
    defaults: { name: 'Орон нутаг', is_rural: true, driver_id: null, sort_order: 0 },
  });
}

/** Resolve service region + driver for new delivery */
exports.findForDelivery = async ({ is_rural, khoroo_id }) => {
  await ensureRuralDefault();
  if (is_rural) {
    return ServiceRegion.findOne({
      where: { is_rural: true },
      include: [{ model: User, as: 'driver', attributes: ['id', 'username'] }],
    });
  }
  const kid = parseInt(khoroo_id, 10);
  if (!kid || Number.isNaN(kid)) return null;
  const link = await ServiceRegionKhoroo.findOne({
    where: { khoroo_id: kid },
    include: [
      {
        model: ServiceRegion,
        as: 'service_region',
        include: [{ model: User, as: 'driver', attributes: ['id', 'username'] }],
      },
    ],
  });
  return link?.service_region ?? null;
};

exports.list = async (req, res) => {
  try {
    await ensureRuralDefault();
    const rows = await ServiceRegion.findAll({
      include: [
        { model: User, as: 'driver', attributes: ['id', 'username'], required: false },
        {
          model: Khoroo,
          as: 'khoroos',
          attributes: ['id', 'name', 'region_id'],
          through: { attributes: [] },
          include: [{ model: Region, as: 'region', attributes: ['id', 'name'] }],
        },
      ],
      order: [
        ['sort_order', 'ASC'],
        ['id', 'ASC'],
      ],
    });
    const data = rows.map((r) => {
      const j = r.toJSON();
      j.khoroo_count = j.khoroos?.length ?? 0;
      return j;
    });
    res.json({ success: true, data });
  } catch (e) {
    console.error('service_region list:', e);
    res.status(500).json({ success: false, message: e.message });
  }
};

exports.create = async (req, res) => {
  const name = req.body.name?.trim();
  if (!name) {
    return res.status(400).json({ success: false, message: 'name is required' });
  }
  if (req.body.is_rural) {
    return res.status(400).json({ success: false, message: 'Cannot create second rural region' });
  }
  try {
    const maxOrder = (await ServiceRegion.max('sort_order')) || 0;
    const row = await ServiceRegion.create({
      name,
      driver_id: null,
      is_rural: false,
      sort_order: maxOrder + 1,
    });
    const full = await ServiceRegion.findByPk(row.id, {
      include: [{ model: User, as: 'driver', attributes: ['id', 'username'] }],
    });
    res.status(201).json({ success: true, data: full });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
};

exports.update = async (req, res) => {
  const id = parseInt(req.params.id, 10);
  try {
    const row = await ServiceRegion.findByPk(id);
    if (!row) return res.status(404).json({ success: false, message: 'Not found' });
    if (req.body.name !== undefined && !row.is_rural) row.name = req.body.name.trim();
    if (req.body.driver_id !== undefined) {
      row.driver_id = req.body.driver_id === null || req.body.driver_id === ''
        ? null
        : parseInt(req.body.driver_id, 10);
    }
    await row.save();
    const full = await ServiceRegion.findByPk(id, {
      include: [
        { model: User, as: 'driver', attributes: ['id', 'username'] },
        {
          model: Khoroo,
          as: 'khoroos',
          through: { attributes: [] },
          include: [{ model: Region, as: 'region', attributes: ['id', 'name'] }],
        },
      ],
    });
    res.json({ success: true, data: full });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
};

exports.setKhoroos = async (req, res) => {
  const id = parseInt(req.params.id, 10);
  const khoroo_ids = req.body.khoroo_ids;
  if (!Array.isArray(khoroo_ids)) {
    return res.status(400).json({ success: false, message: 'khoroo_ids[] required' });
  }
  const t = await db.sequelize.transaction();
  try {
    const row = await ServiceRegion.findByPk(id, { transaction: t });
    if (!row) {
      await t.rollback();
      return res.status(404).json({ success: false, message: 'Not found' });
    }
    if (row.is_rural) {
      await t.rollback();
      return res.status(400).json({ success: false, message: 'Орон нутаг does not use khoroo list' });
    }
    const ids = [...new Set(khoroo_ids.map((x) => parseInt(x, 10)).filter((n) => !Number.isNaN(n)))];
    await ServiceRegionKhoroo.destroy({ where: { service_region_id: id }, transaction: t });
    if (ids.length) {
      await ServiceRegionKhoroo.destroy({
        where: { khoroo_id: ids, service_region_id: { [db.Sequelize.Op.ne]: id } },
        transaction: t,
      });
      await ServiceRegionKhoroo.bulkCreate(
        ids.map((khoroo_id) => ({ service_region_id: id, khoroo_id })),
        { transaction: t }
      );
    }
    await t.commit();
    const full = await ServiceRegion.findByPk(id, {
      include: [
        { model: User, as: 'driver', attributes: ['id', 'username'] },
        {
          model: Khoroo,
          as: 'khoroos',
          through: { attributes: [] },
          include: [{ model: Region, as: 'region', attributes: ['id', 'name'] }],
        },
      ],
    });
    res.json({ success: true, data: full });
  } catch (e) {
    await t.rollback();
    res.status(500).json({ success: false, message: e.message });
  }
};

exports.lookup = async (req, res) => {
  try {
    const is_rural = req.query.is_rural === 'true' || req.query.is_rural === '1';
    const khoroo_id = req.query.khoroo_id;
    const sr = await exports.findForDelivery({ is_rural, khoroo_id });
    if (!sr) {
      return res.json({ success: true, data: null, message: 'No service region matched' });
    }
    res.json({
      success: true,
      data: {
        service_region_id: sr.id,
        service_region_name: sr.name,
        driver_id: sr.driver_id,
        driver_username: sr.driver?.username ?? null,
        is_rural: sr.is_rural,
      },
    });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
};

exports.delete = async (req, res) => {
  const id = parseInt(req.params.id, 10);
  try {
    const row = await ServiceRegion.findByPk(id);
    if (!row) return res.status(404).json({ success: false, message: 'Not found' });
    if (row.is_rural) {
      return res.status(400).json({ success: false, message: 'Cannot delete Орон нутаг' });
    }
    await row.destroy();
    res.json({ success: true });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
};

/** All khoroos grouped by district for admin picker */
exports.khoroosGrouped = async (req, res) => {
  try {
    const districts = await Region.findAll({
      order: [['name', 'ASC']],
      include: [
        {
          model: Khoroo,
          as: 'khoroos',
          attributes: ['id', 'name'],
          separate: true,
          order: [['name', 'ASC']],
        },
      ],
    });
    const assignments = await ServiceRegionKhoroo.findAll({
      attributes: ['khoroo_id', 'service_region_id'],
    });
    const assignMap = {};
    assignments.forEach((a) => {
      assignMap[a.khoroo_id] = a.service_region_id;
    });
    const data = districts.map((d) => ({
      district_id: d.id,
      district_name: d.name,
      khoroos: (d.khoroos || []).map((k) => ({
        id: k.id,
        name: k.name,
        assigned_service_region_id: assignMap[k.id] ?? null,
      })),
    }));
    res.json({ success: true, data });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
};
