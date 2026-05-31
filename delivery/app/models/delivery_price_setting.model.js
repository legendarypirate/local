module.exports = (sequelize, Sequelize) => {
  const DeliveryPriceSetting = sequelize.define(
    'delivery_price_setting',
    {
      label: {
        type: Sequelize.STRING(120),
        allowNull: true,
      },
      merchant_price: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      driver_price: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      is_default: {
        type: Sequelize.BOOLEAN,
        allowNull: false,
        defaultValue: false,
      },
    },
    {
      tableName: 'delivery_price_settings',
      timestamps: true,
    }
  );

  return DeliveryPriceSetting;
};
