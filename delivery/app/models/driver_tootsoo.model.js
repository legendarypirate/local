module.exports = (sequelize, Sequelize) => {
  const DriverTootsoo = sequelize.define(
    "driver_tootsoo",
    {
      driver_id: { type: Sequelize.INTEGER, allowNull: false },
      start_date: { type: Sequelize.DATEONLY, allowNull: false },
      end_date: { type: Sequelize.DATEONLY, allowNull: false },
      total_price: { type: Sequelize.DECIMAL(12, 2), allowNull: false, defaultValue: 0 },
      for_driver: { type: Sequelize.DECIMAL(12, 2), allowNull: false, defaultValue: 0 },
      extra_deduction: { type: Sequelize.DECIMAL(12, 2), allowNull: true, defaultValue: 0 },
      account: { type: Sequelize.DECIMAL(12, 2), allowNull: false, defaultValue: 0 },
      number_delivery: { type: Sequelize.INTEGER, allowNull: true, defaultValue: 0 },
      delivery_ids: { type: Sequelize.JSON, allowNull: true },
      status: { type: Sequelize.INTEGER, allowNull: false, defaultValue: 1 }, // 1 = unpaid, 2 = paid
    },
    { tableName: "driver_tootsoos" }
  );
  return DriverTootsoo;
};
