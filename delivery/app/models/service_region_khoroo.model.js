module.exports = (sequelize, Sequelize) => {
  const ServiceRegionKhoroo = sequelize.define(
    'service_region_khoroo',
    {
      service_region_id: { type: Sequelize.INTEGER, allowNull: false, primaryKey: true },
      khoroo_id: { type: Sequelize.INTEGER, allowNull: false, primaryKey: true },
    },
    { tableName: 'service_region_khoroos', timestamps: false }
  );
  return ServiceRegionKhoroo;
};
