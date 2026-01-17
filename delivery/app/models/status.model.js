module.exports = (sequelize, Sequelize) => {
    const Status = sequelize.define("status", {
      status: {
        type: Sequelize.STRING
      },
      color: {
        type: Sequelize.STRING
      },
    });
    return Status;
};
  