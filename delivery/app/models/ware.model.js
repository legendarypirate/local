module.exports = (sequelize, Sequelize) => {
    const Ware = sequelize.define("ware", {
      name: {
        type: Sequelize.STRING
      },
    });

    return Ware;
};
  