module.exports = (sequelize, Sequelize) => {
  const DeliveryAddressRequest = sequelize.define(
    "delivery_address_request",
    {
      delivery_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      requested_by_user_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
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
      },
      admin_note: {
        type: Sequelize.TEXT,
        allowNull: true,
      },
    },
    {
      tableName: "delivery_address_requests",
      timestamps: true,
    }
  );

  return DeliveryAddressRequest;
};
