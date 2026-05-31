'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('deliveries', 'service_region_id', {
      type: Sequelize.INTEGER,
      allowNull: true,
      references: { model: 'service_regions', key: 'id' },
      onUpdate: 'CASCADE',
      onDelete: 'SET NULL',
    });
    await queryInterface.addIndex('deliveries', ['service_region_id'], {
      name: 'deliveries_service_region_id_idx',
    });
  },

  async down(queryInterface) {
    await queryInterface.removeIndex('deliveries', 'deliveries_service_region_id_idx');
    await queryInterface.removeColumn('deliveries', 'service_region_id');
  },
};
