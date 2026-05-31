'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('delivery_price_settings', {
      id: {
        type: Sequelize.INTEGER,
        autoIncrement: true,
        primaryKey: true,
      },
      label: {
        type: Sequelize.STRING(120),
        allowNull: true,
      },
      merchant_price: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      driver_price: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      is_default: {
        type: Sequelize.BOOLEAN,
        allowNull: false,
        defaultValue: false,
      },
      createdAt: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
      },
      updatedAt: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
      },
    });

    await queryInterface.bulkInsert('delivery_price_settings', [
      {
        label: 'Стандарт',
        merchant_price: 6000,
        driver_price: 4000,
        is_default: true,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
    ]);

    await queryInterface.addColumn('deliveries', 'price_setting_id', {
      type: Sequelize.INTEGER,
      allowNull: true,
      references: { model: 'delivery_price_settings', key: 'id' },
      onUpdate: 'CASCADE',
      onDelete: 'SET NULL',
    });
  },

  async down(queryInterface) {
    await queryInterface.removeColumn('deliveries', 'price_setting_id');
    await queryInterface.dropTable('delivery_price_settings');
  },
};
