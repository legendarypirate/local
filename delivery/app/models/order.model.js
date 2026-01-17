module.exports = (sequelize, Sequelize) => {
    const Order = sequelize.define("order", {
      merchant_id: {
        type: Sequelize.INTEGER,
      },
      phone: {
        type: Sequelize.STRING,
        defaultValue: 0
      },
      address: {
        type: Sequelize.STRING,
        defaultValue: 0
      },
      status: {
        type: Sequelize.INTEGER,
        defaultValue: 0
      },
      driver_id: {
        type: Sequelize.INTEGER,
        allowNull: true, // <- allow no driver initially
        defaultValue: null,
      },      
      comment: {
        type: Sequelize.STRING,
        defaultValue: 0
      },
    });
  
    return Order;
  };
  