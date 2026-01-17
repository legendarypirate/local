module.exports = (sequelize, Sequelize) => {
    const DeliveryItem = sequelize.define("delivery_item", {
      delivery_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'deliveries',
          key: 'id',
        },
        onDelete: 'CASCADE',
      },
      good_id: {
        type: Sequelize.INTEGER,
        allowNull: true, // allowNull true if some deliveries don't have goods
        references: {
          model: 'goods',
          key: 'id',
        },
        onDelete: 'SET NULL',
      },
      quantity: {
        type: Sequelize.INTEGER,
        allowNull: false,
        defaultValue: 1,
      },
    });
  
    return DeliveryItem;
  };
  