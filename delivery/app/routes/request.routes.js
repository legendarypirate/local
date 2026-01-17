module.exports = app => {
    const request = require("../controllers/request.controller.js");
  
    var router = require("express").Router();
    router.post("/stock", request.createRequest);

    // Create a new Request
    router.post("/", request.create);

    router.put("/approve/:id", request.approve);

    // Decline a Request
    router.put("/decline/:id", request.decline);
    // Retrieve all Requests
    router.get("/", request.findAll);
  
    // Retrieve a single Request by ID
    router.get("/:id", request.findOne);
  
    // Update a Request by ID
    router.put("/:id", request.update);
  
    // Delete a Request by ID
    router.delete("/:id", request.delete);
  
    // Delete all Requests
    router.delete("/", request.deleteAll);
  
    app.use('/api/request', router);
  };
  