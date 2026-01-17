module.exports = (sequelize, Sequelize) => {
    const Region = sequelize.define("region", {
      name: {
        type: Sequelize.STRING
      }
   
    });
    return Region;
};
  