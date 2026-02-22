module.exports = app => {
    const user = require("../controllers/user.controller.js");
  
    var router = require("express").Router();

    // Create a new Tutorial
    router.post("/", user.create);
    router.get("/merchant", user.findMerchants);

    // Retrieve all Tutorials
  
    // Retrieve all published Tutorials
    router.get("/published", user.findAllPublished);
    router.get("/drivers", user.findDrivers); // ✅ NEW ROUTE HERE
    router.get("/drivers-with-stats", user.findDriversWithDeliveryCount);

    // Retrieve a single Tutorial with id
    router.get("/:id", user.findOne);
  
    // Update a Tutorial with id
    router.put("/:id", user.update);
  
    // Delete a Tutorial with id
    router.delete("/:id", user.delete);
  
    // Delete all Tutorials
    router.delete("/", user.deleteAll);
    router.get("/", user.findAll);

    app.use('/api/user', router);
  };
  