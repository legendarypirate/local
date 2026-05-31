const db = require('../models');

const KHOROO_MIN = 1;
const KHOROO_MAX = 50;

/** Sort khoroo rows by numeric name (1 … 50). */
function sortKhoroosByNumber(rows) {
  return [...rows].sort(
    (a, b) => parseInt(String(a.name), 10) - parseInt(String(b.name), 10)
  );
}

/** Reset all khoroos: clear assignments, then 1–50 per district. */
async function seedStandardKhoroos() {
  const Region = db.regions;
  const Khoroo = db.khoroos;
  const t = await db.sequelize.transaction();
  try {
    await db.sequelize.query('DELETE FROM service_region_khoroos', { transaction: t });
    await db.sequelize.query('UPDATE deliveries SET khoroo_id = NULL', { transaction: t });
    await Khoroo.destroy({ where: {}, transaction: t });

    const districts = await Region.findAll({ order: [['id', 'ASC']], transaction: t });
    const now = new Date();
    const rows = [];
    for (const d of districts) {
      for (let n = KHOROO_MIN; n <= KHOROO_MAX; n++) {
        rows.push({
          name: String(n),
          region_id: d.id,
          createdAt: now,
          updatedAt: now,
        });
      }
    }
    if (rows.length) {
      await Khoroo.bulkCreate(rows, { transaction: t });
    }
    await t.commit();
    return { districts: districts.length, khoroosPerDistrict: KHOROO_MAX, total: rows.length };
  } catch (e) {
    await t.rollback();
    throw e;
  }
}

module.exports = {
  KHOROO_MIN,
  KHOROO_MAX,
  sortKhoroosByNumber,
  seedStandardKhoroos,
};
