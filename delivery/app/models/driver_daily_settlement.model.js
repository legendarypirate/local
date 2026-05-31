module.exports = (sequelize, Sequelize) => {
  const DriverDailySettlement = sequelize.define(
    'driver_daily_settlement',
    {
      driver_id: { type: Sequelize.INTEGER, allowNull: false },
      settlement_date: { type: Sequelize.DATEONLY, allowNull: false },
      total_amount: { type: Sequelize.INTEGER, allowNull: false, defaultValue: 0 },
      driver_salary: { type: Sequelize.INTEGER, allowNull: false, defaultValue: 0 },
      difference: { type: Sequelize.INTEGER, allowNull: false, defaultValue: 0 },
      amount_paid: { type: Sequelize.INTEGER, allowNull: false, defaultValue: 0 },
    },
    { tableName: 'driver_daily_settlements', timestamps: true }
  );
  return DriverDailySettlement;
};
