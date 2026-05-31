module.exports = (sequelize, Sequelize) => {
  const ServiceRegion = sequelize.define(
    'service_region',
    {
      name: { type: Sequelize.STRING(120), allowNull: false },
      driver_id: { type: Sequelize.INTEGER, allowNull: true },
      is_rural: { type: Sequelize.BOOLEAN, allowNull: false, defaultValue: false },
      sort_order: { type: Sequelize.INTEGER, allowNull: false, defaultValue: 0 },
    },
    { tableName: 'service_regions', timestamps: true }
  );
  return ServiceRegion;
};
