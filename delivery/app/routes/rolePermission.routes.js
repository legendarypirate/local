module.exports = app => {
    const rolePermission = require("../controllers/role_permission.controller.js");
  
    var router = require("express").Router();
  
    // Create a new role_permission (assign permission to a role)
    router.get('/:roleId', rolePermission.getByRoleId);

    router.post('/:roleId', rolePermission.savePermissionsForRole);

    // Retrieve all role_permissions
    router.get("/", rolePermission.findAll);
  
    // Retrieve a single role_permission with id
    router.get("/:id", rolePermission.findOne);
  

    // Update a role_permission with id
    router.put("/:id", rolePermission.update);
  
    // Delete a role_permission with id
    router.delete("/:id", rolePermission.delete);
  
    // Delete all role_permissions
    router.delete("/", rolePermission.deleteAll);
  
    app.use('/api/role_permission', router);
  };
  