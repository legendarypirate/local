module.exports = app => {
    const region = require("../controllers/region.controller.js");
  
    var router = require("express").Router();
  
    // Create a new Tutorial
    router.post("/", region.create);
  
    // Retrieve all Tutorials
    router.get("/", region.findAll);
  
    // Retrieve all published Tutorials
    router.get("/published", region.findAllPublished);
  
    // Retrieve a single Tutorial with id
    router.get("/:id", region.findOne);
  
    // Update a Tutorial with id
    router.put("/:id", region.update);
  
    // Delete a Tutorial with id
    router.delete("/:id", region.delete);
  
    // Delete all Tutorials
    router.delete("/", region.deleteAll);
  
    app.use('/api/region', router);
  };
  