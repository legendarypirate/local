const db = require("../models");
const RolePermission = db.role_permissions;
const Op = db.Sequelize.Op;
const Permission = db.permissions;

// Create and Save a new role_permission


exports.savePermissionsForRole = async (req, res) => {
  const roleId = req.params.roleId;
  const permissionIds = req.body.permissions; // e.g., [1, 2, 3, 4]

  if (!Array.isArray(permissionIds)) {
    return res.status(400).json({ message: "permissions should be an array of IDs" });
  }

  try {
    // Delete old permissions for this role
    await RolePermission.destroy({ where: { role_id: roleId } });

    // Insert new ones
    const newRolePermissions = permissionIds.map(pid => ({
      role_id: roleId,
      permission_id: pid,
    }));

    await RolePermission.bulkCreate(newRolePermissions);

    res.json({ message: "Permissions saved successfully" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Failed to save permissions" });
  }
};

// Retrieve all role_permissions from the database.
exports.findAll = async (req, res) => {
  try {
    const data = await RolePermission.findAll();
    res.send({
      success: true,
      data: data,
    });
  } catch (err) {
    res.status(500).send({
      message: err.message || "Some error occurred while retrieving role_permissions."
    });
  }
};

exports.getByRoleId = async (req, res) => {
  const roleId = req.params.roleId;

  try {
    const rolePermissions = await RolePermission.findAll({
      where: { role_id: roleId },
      include: [
        {
          model: Permission,
          as: 'permission',
          attributes: ['id', 'module', 'action', 'description']
        }
      ]
    });

    if (!rolePermissions || rolePermissions.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'No permissions found for this role',
        data: []
      });
    }

    // Extract only permission objects to send in data
    const permissions = rolePermissions.map(rp => rp.permission);

    res.json({
      success: true,
      data: permissions
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: 'Server error'
    });
  }
};


// Find a single role_permission with an id
exports.findOne = async (req, res) => {
  const id = req.params.id;

  try {
    const data = await RolePermission.findByPk(id);
    if (data) {
      res.send(data);
    } else {
      res.status(404).send({
        message: `Cannot find role_permission with id=${id}.`
      });
    }
  } catch (err) {
    res.status(500).send({
      message: "Error retrieving role_permission with id=" + id
    });
  }
};

// Update a role_permission by the id in the request
exports.update = async (req, res) => {
  const id = req.params.id;

  try {
    const num = await RolePermission.update(req.body, {
      where: { id: id }
    });
    if (num == 1) {
      res.send({
        message: "role_permission was updated successfully."
      });
    } else {
      res.send({
        message: `Cannot update role_permission with id=${id}. Maybe role_permission was not found or req.body is empty!`
      });
    }
  } catch (err) {
    res.status(500).send({
      message: "Error updating role_permission with id=" + id
    });
  }
};

// Delete a role_permission with the specified id in the request
exports.delete = async (req, res) => {
  const id = req.params.id;

  try {
    const num = await RolePermission.destroy({
      where: { id: id }
    });
    if (num == 1) {
      res.send({
        message: "role_permission was deleted successfully!"
      });
    } else {
      res.send({
        message: `Cannot delete role_permission with id=${id}. Maybe role_permission was not found!`
      });
    }
  } catch (err) {
    res.status(500).send({
      message: "Could not delete role_permission with id=" + id
    });
  }
};

// Delete all role_permissions from the database.
exports.deleteAll = async (req, res) => {
  try {
    const nums = await RolePermission.destroy({
      where: {},
      truncate: false
    });
    res.send({ message: `${nums} role_permissions were deleted successfully!` });
  } catch (err) {
    res.status(500).send({
      message: err.message || "Some error occurred while removing all role_permissions."
    });
  }
};
