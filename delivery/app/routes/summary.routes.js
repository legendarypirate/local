module.exports = app => {
    const summary = require("../controllers/summary.controller.js");
  
    const router = require("express").Router();
  
    // Create a new Summary
    router.post("/", summary.create);
  
    // Retrieve all summaries
    router.get("/", summary.findAll);
  
    // Retrieve a single summary by ID
    router.get("/:id", summary.findOne);
  
    // Update a summary by ID
    router.patch("/:id", summary.update);
  
    // Delete a summary by ID
    router.delete("/:id", summary.delete);
  
    // Delete all summaries
    router.delete("/", summary.deleteAll);
  
    app.use('/api/summary', router);
  };
  