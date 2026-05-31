module.exports = (sequelize, Sequelize) => {
  const DriverSettlementPayment = sequelize.define(
    'driver_settlement_payment',
    {
      settlement_id: { type: Sequelize.INTEGER, allowNull: false },
      amount: { type: Sequelize.INTEGER, allowNull: false },
      note: { type: Sequelize.STRING(500), allowNull: true },
    },
    { tableName: 'driver_settlement_payments', timestamps: true, updatedAt: false }
  );
  return DriverSettlementPayment;
};
