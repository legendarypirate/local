module.exports = app => {
    const info = require("../controllers/info.controller.js");
  
    var router = require("express").Router();
  
    // Create a new Tutorial
    router.post("/", info.create);
  
    // Retrieve all Tutorials
    router.get("/", info.findAll);
  
    // Retrieve all published Tutorials
    router.get("/published", info.findAllPublished);
  
    // Retrieve a single Tutorial with id
    router.get("/:id", info.findOne);
  
    // Update a Tutorial with id
    router.patch("/:id", info.update);
  
    // Delete a Tutorial with id
    router.delete("/:id", info.delete);
  
    // Delete all Tutorials
    router.delete("/", info.deleteAll);
  
    app.use('/api/info', router);
  };
  