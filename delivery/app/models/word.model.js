module.exports = (sequelize, Sequelize) => {
    const Ware = sequelize.define("word", {
      ware_id: {
        type: Sequelize.STRING
      },
      merchant_id: {
        type: Sequelize.INTEGER,
        defaultValue: 0
      },
      stock: {
        type: Sequelize.INTEGER,
        defaultValue: 0
      },
      name: {
        type: Sequelize.STRING
      },
     
    });
  
    return Ware;
  };
  