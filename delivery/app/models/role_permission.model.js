module.exports = (sequelize, Sequelize) => {
    const RolePermission = sequelize.define("role_permission", {
      role_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      permission_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
    }, {
      timestamps: false,
      tableName: 'role_permissions'
    });
  
    return RolePermission;
  };
  