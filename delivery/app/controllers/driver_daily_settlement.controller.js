const db = require('../models');
const DriverDailySettlement = db.driver_daily_settlements;
const DriverSettlementPayment = db.driver_settlement_payments;
const User = db.users;
const { Op } = db.Sequelize;

function remainingAmount(row) {
  const due = Number(row.total_amount ?? 0);
  const paid = Number(row.amount_paid ?? 0);
  return Math.max(0, due - paid);
}

function formatRow(row) {
  const j = row.toJSON ? row.toJSON() : row;
  j.remaining = remainingAmount(j);
  j.is_paid = j.remaining <= 0 && j.total_amount > 0;
  return j;
}

/** GET with settlements merged — mobile report + admin list */
exports.list = async (req, res) => {
  const driver_id = parseInt(req.query.driver_id, 10);
  const start_date = req.query.start_date;
  const end_date = req.query.end_date;

  if (!driver_id || !start_date || !end_date) {
    return res.status(400).json({
      success: false,
      message: 'driver_id, start_date, end_date are required',
    });
  }

  try {
    const rows = await DriverDailySettlement.findAll({
      where: {
        driver_id,
        settlement_date: { [Op.between]: [start_date, end_date] },
      },
      include: [
        {
          model: DriverSettlementPayment,
          as: 'payments',
          separate: true,
          order: [['createdAt', 'DESC']],
        },
        { model: User, as: 'driver', attributes: ['id', 'username'], required: false },
      ],
      order: [['settlement_date', 'DESC']],
    });

    res.json({
      success: true,
      data: rows.map((r) => formatRow(r)),
    });
  } catch (e) {
    console.error(e);
    res.status(500).json({ success: false, message: e.message || 'Server error' });
  }
};

/** Upsert daily snapshot from report row + record payment */
exports.recordPayment = async (req, res) => {
  const driver_id = parseInt(req.body.driver_id, 10);
  const settlement_date = req.body.settlement_date;
  const amount = parseInt(req.body.amount, 10);
  const note = req.body.note?.trim() || null;
  const total_amount = parseInt(req.body.total_amount, 10);
  const driver_salary = parseInt(req.body.driver_salary, 10);
  const difference = parseInt(req.body.difference, 10);

  if (!driver_id || !settlement_date) {
    return res.status(400).json({ success: false, message: 'driver_id and settlement_date required' });
  }
  if (Number.isNaN(amount) || amount <= 0) {
    return res.status(400).json({ success: false, message: 'amount must be a positive number' });
  }

  const t = await db.sequelize.transaction();
  try {
    let row = await DriverDailySettlement.findOne({
      where: { driver_id, settlement_date },
      transaction: t,
      lock: t.LOCK.UPDATE,
    });

    if (!row) {
      if ([total_amount, driver_salary, difference].some((n) => Number.isNaN(n))) {
        await t.rollback();
        return res.status(400).json({
          success: false,
          message: 'total_amount, driver_salary, difference required for new day',
        });
      }
      row = await DriverDailySettlement.create(
        {
          driver_id,
          settlement_date,
          total_amount: total_amount || 0,
          driver_salary: driver_salary || 0,
          difference: difference || 0,
          amount_paid: 0,
        },
        { transaction: t }
      );
    } else if (!Number.isNaN(total_amount)) {
      await row.update(
        {
          total_amount,
          driver_salary: Number.isNaN(driver_salary) ? row.driver_salary : driver_salary,
          difference: Number.isNaN(difference) ? row.difference : difference,
        },
        { transaction: t }
      );
    }

    const remaining = remainingAmount(row);
    if (amount > remaining) {
      await t.rollback();
      return res.status(400).json({
        success: false,
        message: `Төлбөр хэтэрсэн. Үлдэгдэл: ${remaining}₮`,
      });
    }

    await DriverSettlementPayment.create(
      { settlement_id: row.id, amount, note },
      { transaction: t }
    );

    await row.update({ amount_paid: Number(row.amount_paid) + amount }, { transaction: t });

    await t.commit();

    const fresh = await DriverDailySettlement.findByPk(row.id, {
      include: [{ model: DriverSettlementPayment, as: 'payments', separate: true, order: [['createdAt', 'DESC']] }],
    });

    res.json({ success: true, data: formatRow(fresh), message: 'Төлбөр бүртгэгдлээ' });
  } catch (e) {
    await t.rollback();
    console.error(e);
    res.status(500).json({ success: false, message: e.message || 'Server error' });
  }
};

/** Sync report rows into settlement table (no payment) */
exports.syncFromReport = async (req, res) => {
  const driver_id = parseInt(req.body.driver_id, 10);
  const days = req.body.days;

  if (!driver_id || !Array.isArray(days)) {
    return res.status(400).json({ success: false, message: 'driver_id and days[] required' });
  }

  const t = await db.sequelize.transaction();
  try {
    for (const d of days) {
      const date = d.date;
      if (!date) continue;
      const total_amount = parseInt(d.total_amount, 10) || 0;
      const driver_salary = parseInt(d.driver_salary, 10) || 0;
      const difference = parseInt(d.difference, 10) || 0;

      const [row] = await DriverDailySettlement.findOrCreate({
        where: { driver_id, settlement_date: date },
        defaults: {
          driver_id,
          settlement_date: date,
          total_amount,
          driver_salary,
          difference,
          amount_paid: 0,
        },
        transaction: t,
      });

      await row.update({ total_amount, driver_salary, difference }, { transaction: t });
    }
    await t.commit();
    res.json({ success: true, message: 'Synced' });
  } catch (e) {
    await t.rollback();
    console.error(e);
    res.status(500).json({ success: false, message: e.message || 'Server error' });
  }
};
