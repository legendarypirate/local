module.exports = (sequelize, Sequelize) => {
    const Request = sequelize.define("request", {
      ware_id: {
        type: Sequelize.INTEGER,
      },
      merchant_id: {
        type: Sequelize.INTEGER,
        defaultValue: 0,
      },
      stock: {
        type: Sequelize.INTEGER,
        defaultValue: 0,
      },
      approved_stock: {
        type: Sequelize.INTEGER,
        allowNull: true,
        defaultValue: null,
      },
      status: {
        type: Sequelize.INTEGER,
        defaultValue: 1,
      },
       good_id: {
        type: Sequelize.INTEGER,
        allowNull: true,  // allow null if no good linked yet
        defaultValue: null
      },
      name: {
        type: Sequelize.STRING,
      },
      type: {
        type: Sequelize.INTEGER,
        allowNull: false, // or true if optional
        validate: {
          isIn: [[1, 2, 3]], // optional validation
        },
      },
    });
  
    return Request;
  };
  