'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('driver_daily_settlements', 'delivery_count', {
      type: Sequelize.INTEGER,
      allowNull: false,
      defaultValue: 0,
      comment: 'Хүргэлтийн тоо (өдрийн нийт)',
    });
  },

  async down(queryInterface) {
    await queryInterface.removeColumn('driver_daily_settlements', 'delivery_count');
  },
};
