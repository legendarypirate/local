module.exports = (sequelize, Sequelize) => {
  const History = sequelize.define("history", {
    merchant_id: {
      type: Sequelize.INTEGER,
    },
    delivery_id: {
      type: Sequelize.INTEGER,
      defaultValue: 0,
    },
    driver_id: {
      type: Sequelize.INTEGER,
      allowNull: true,  // NULL утгыг зөвшөөрнө
    },
     status: {
      type: Sequelize.INTEGER,
    },
  });

  return History;
};
