module.exports = (sequelize, Sequelize) => {
    const Summary = sequelize.define("summary", {
      merchant_id: {
        type: Sequelize.INTEGER,
 allowNull: true,
        allowNull: true,
      },
      number_delivery: {
        type: Sequelize.INTEGER,
        allowNull: true,
      },
      total: {
        type: Sequelize.DECIMAL(10, 2),
        allowNull: false,
        defaultValue: 0
      },
      driver: {
        type: Sequelize.DECIMAL(10, 2),
        allowNull: false,
        defaultValue: 0
      },
      account: {
        type: Sequelize.DECIMAL(10, 2),
        allowNull: false,
        defaultValue: 0
      },
      comment: {
        type: Sequelize.STRING,
        allowNull: false,
        defaultValue: 0
      },
      driver_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        defaultValue: 0
      },
    
    });
  
    return Summary;
  };
  