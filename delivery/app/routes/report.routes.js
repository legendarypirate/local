module.exports = app => {
    const report = require("../controllers/report.controller.js");
  
    var router = require("express").Router();
    router.get("/:id/deliveries", report.findDeliveriesByReportId);

    // Create a new Tutorial
    router.post("/driver", report.getTotalPriceByDriverAndDate);
  
    router.post("/merchant", report.getTotalPriceByMerchantAndDate);

    // Retrieve all Tutorials
    router.get("/", report.findAll);
  
    // Retrieve all published Tutorials
    router.get("/published", report.findAllPublished);
  
    // Retrieve a single Tutorial with id
    router.get("/:id", report.findOne);
  
    // Update a Tutorial with id
    router.patch("/:id", report.update);
  
    // Delete a Tutorial with id
    router.delete("/:id", report.delete);
  
    // Delete all Tutorials
    router.delete("/", report.deleteAll);
  

    app.use('/api/report', router);
  };
  