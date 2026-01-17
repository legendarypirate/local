module.exports = (sequelize, Sequelize) => {
    const Khoroo = sequelize.define("khoroo", {
      name: {
        type: Sequelize.STRING,
        allowNull: false
      },
      region_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'regions',
          key: 'id',
        },
      }
    });
    return Khoroo;
};

