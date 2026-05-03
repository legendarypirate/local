module.exports = (sequelize, Sequelize) => {
  const DeliveryZone = sequelize.define("delivery_zone", {
    name: {
      type: Sequelize.STRING,
      allowNull: false,
    },
    driver_id: {
      type: Sequelize.INTEGER,
      allowNull: false,
    },
    // Array of { lat, lng } (or [lat, lng]) - closed polygon
    coordinates: {
      type: Sequelize.JSONB,
      allowNull: false,
      defaultValue: [],
    },
  });
  return DeliveryZone;
};
