module.exports = app => {
    const khoroo = require("../controllers/khoroo.controller.js");
  
    var router = require("express").Router();
  
    // Create a new Khoroo
    router.post("/", khoroo.create);
  
    // Retrieve all Khoroos
    router.get("/", khoroo.findAll);
  
    // Retrieve a single Khoroo with id
    router.get("/:id", khoroo.findOne);
  
    // Update a Khoroo with id
    router.put("/:id", khoroo.update);
  
    // Delete a Khoroo with id
    router.delete("/:id", khoroo.delete);
  
    app.use('/api/khoroo', router);
  };

