module.exports = app => {
    const delivery = require("../controllers/delivery.controller.js");
  
    var router = require("express").Router();
    router.get("/statistic", delivery.statistic);
  router.post("/status", delivery.status);

    router.post("/allocate", delivery.allocateDeliveries);
    router.get("/findAllWithDate", delivery.findAllWithDate);

    // Create a new Tutorial
    router.post("/", delivery.create);
  
    // Retrieve all Tutorials
    router.get("/", delivery.findAll);
    router.get('/delivery-status-counts', delivery.getStatusCounts);

  router.get("/:deliveryId/items", delivery.getItemsByDeliveryId);
  router.get("/:id/history", delivery.getDeliveryHistory);


  router.post("/delete-multiple", delivery.deleteMultiple);
  router.put("/bulk-delivery-price", delivery.bulkUpdateDeliveryPrice);

    // Retrieve all published Tutorials
    router.get("/published", delivery.findAllPublished);
  
    // Retrieve a single Tutorial with id
    router.get("/:id", delivery.findOne);
  
    // Update a Tutorial with id
    router.put("/:id", delivery.update);

    router.post('/import', delivery.importExcelDeliveries);

    // Delete a Tutorial with id
    router.delete("/:id", delivery.delete);
  
    // Delete all Tutorials
    router.delete("/", delivery.deleteAll);
  
    app.use('/api/delivery', router);
  };
  