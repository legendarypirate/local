"use strict";

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable("delivery_address_requests", {
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
      previous_address: {
        type: Sequelize.TEXT,
        allowNull: false,
      },
      new_address: {
        type: Sequelize.TEXT,
        allowNull: false,
      },
      status: {
        type: Sequelize.STRING(20),
        allowNull: false,
        defaultValue: "pending",
      },
      new_driver_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: { model: "users", key: "id" },
        onUpdate: "CASCADE",
        onDelete: "SET NULL",
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
    await queryInterface.addIndex("delivery_address_requests", ["delivery_id"]);
    await queryInterface.addIndex("delivery_address_requests", ["status"]);
  },

  async down(queryInterface) {
    await queryInterface.dropTable("delivery_address_requests");
  },
};
