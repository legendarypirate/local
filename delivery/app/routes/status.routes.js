module.exports = app => {
    const status = require("../controllers/status.controller.js");
  
    var router = require("express").Router();
  
    // Create a new Tutorial
    router.post("/", status.create);
  
    // Retrieve all Tutorials
    router.get("/", status.findAll);
  
    // Retrieve all published Tutorials
    router.get("/published", status.findAllPublished);
  
    // Retrieve a single Tutorial with id
    router.get("/:id", status.findOne);
  
    // Update a Tutorial with id
    router.patch("/:id", status.update);
  
    // Delete a Tutorial with id
    router.delete("/:id", status.delete);
  
    // Delete all Tutorials
    router.delete("/", status.deleteAll);
  
    app.use('/api/status', router);
  };
  