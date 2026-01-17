module.exports = app => {
    const good = require("../controllers/good.controller.js");
  
    var router = require("express").Router();

    router.patch("/:id/stock", good.updateStock);
    // Create a new Tutorial
    router.post("/", good.create);
  
    // Retrieve all Tutorials
    router.get("/", good.findAll);
  
    // Retrieve all published Tutorials
    router.get("/published", good.findAllPublished);
  
    // Retrieve a single Tutorial with id
    router.get("/:id", good.findOne);
  
    // Update a Tutorial with id
    router.patch("/:id", good.update);
  
    // Delete a Tutorial with id
    router.delete("/:id", good.delete);
  
    // Delete all Tutorials
    router.delete("/", good.deleteAll);
  

    app.use('/api/good', router);
  };
  