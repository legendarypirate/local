module.exports = app => {
    const notification = require("../controllers/notification.controller.js");
  
    var router = require("express").Router();
  
    // Create a new Tutorial
    router.post("/", notification.create);
  
    // Retrieve all Tutorials
    router.get("/", notification.findAll);
  
    // Retrieve all published Tutorials
    router.get("/published", notification.findAllPublished);
  
    // Retrieve a single Tutorial with id
    router.get("/:id", notification.findOne);
  
    // Update a Tutorial with id
    router.put("/:id", notification.update);
  
    // Delete a Tutorial with id
    router.delete("/:id", notification.delete);
  
    // Delete all Tutorials
    router.delete("/", notification.deleteAll);
  
    app.use('/api/notification', router);
  };
  