"use strict";

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable("delivery_not_picked_requests", {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      delivery_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: { model: "deliveries", key: "id" },
        onUpdate: "CASCADE",
        onDelete: "CASCADE",
      },
      requested_by_user_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: { model: "users", key: "id" },
        onUpdate: "CASCADE",
        onDelete: "CASCADE",
      },
      driver_comment: {
        type: Sequelize.TEXT,
        allowNull: true,
      },
      status: {
        type: Sequelize.STRING(20),
        allowNull: false,
        defaultValue: "pending",
      },
      admin_note: {
        type: Sequelize.TEXT,
        allowNull: true,
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE,
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE,
      },
    });
    await queryInterface.addIndex("delivery_not_picked_requests", ["delivery_id"]);
    await queryInterface.addIndex("delivery_not_picked_requests", ["status"]);
  },

  async down(queryInterface) {
    await queryInterface.dropTable("delivery_not_picked_requests");
  },
};
