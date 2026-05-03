module.exports = (sequelize, Sequelize) => {
  const DeliveryNotPickedRequest = sequelize.define(
    "delivery_not_picked_request",
    {
      delivery_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      requested_by_user_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
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
    },
    {
      tableName: "delivery_not_picked_requests",
      timestamps: true,
    }
  );

  return DeliveryNotPickedRequest;
};
