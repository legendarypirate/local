module.exports = app => {
    const delivery = require("../controllers/delivery.mobile.controller.js");
    var router = require("express").Router();

    router.get("/reportcustomer", delivery.getCounts);

    router.get("/reportdata", delivery.getDeliveryStatusSummary);

    router.get("/report", delivery.report);
    router.get("/merchant", delivery.findMerchantDelivery);
    router.get("/driver/:id/status-3", delivery.findDeliveryDone);

    router.get('/:driver_id/status-counts', delivery.getStatusCountsByDriver);

    // Get deliveries for a driver (mobile)
    router.get("/my", delivery.findUserDeliveries);

    router.get("/eachstatus/:id/:status", delivery.findWithStatus);


    // Mark delivery as complete
    router.post("/complete/:id", delivery.completeDelivery);
    router.post("/:id/address-request", delivery.createAddressChangeRequest);
    router.post("/:id/not-picked-request", delivery.createNotPickedRequest);
    router.get("/driver/:id/status-2", delivery.findDriverDeliveriesWithStatus);
    router.get("/:deliveryId", delivery.findByDeliverId);

    router.get("/eachstatuscustomer/:id/:status", delivery.findWithStatusCustomer);

    app.use('/api/mobile/delivery', router);
};
