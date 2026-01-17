// models/log.js
module.exports = (sequelize, Sequelize) => {
    const Log = sequelize.define('Log', {
      action: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      table: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      userId: {
        type: Sequelize.INTEGER,
        allowNull: true,
      },
      values: {
        type: Sequelize.JSONB, // or Sequelize.TEXT if you prefer stringifying the body
        allowNull: true,
      },
    });
  
    return Log;
  };
  