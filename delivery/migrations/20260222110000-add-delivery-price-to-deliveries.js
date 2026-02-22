'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('deliveries', 'delivery_price', {
      type: Sequelize.INTEGER,
      allowNull: false,
      defaultValue: 6000,
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn('deliveries', 'delivery_price');
  }
};
