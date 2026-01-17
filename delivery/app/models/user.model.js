module.exports = (sequelize, Sequelize) => {
    const User = sequelize.define("user", {
      username: {
        type: Sequelize.STRING
      },
      password: {
        type: Sequelize.STRING
      },
      role_id: {
        type: Sequelize.INTEGER
      },
      phone: {
        type: Sequelize.STRING
      },
 contact_info: {
        type: Sequelize.STRING,
        allowNull: true

      },
      email: {
        type: Sequelize.STRING
      },
      bank: {
        type: Sequelize.STRING,
        allowNull: true
      },
      account_number: {
        type: Sequelize.STRING,
        allowNull: true
      },
      address: {
        type: Sequelize.TEXT,
        allowNull: true
      }
    });
    return User;
  };