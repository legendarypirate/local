module.exports = app => {
    const order = require("../controllers/order.controller.js");
  
    var router = require("express").Router();
    router.post("/allocate", order.allocateDeliveries);

    // Create a new Tutorial
    router.post("/", order.create);
  
    // Retrieve all Tutorials
    router.get("/", order.findAll);
  
    // Retrieve all published Tutorials
    router.get("/published", order.findAllPublished);
  
    // Retrieve a single Tutorial with id
    router.get("/:id", order.findOne);
  
    // Update a Tutorial with id
    router.patch("/:id", order.update);
  
    // Delete a Tutorial with id
    router.delete("/:id", order.delete);
  
    // Delete all Tutorials
    router.delete("/", order.deleteAll);
  
    app.use('/api/order', router);
  };
  