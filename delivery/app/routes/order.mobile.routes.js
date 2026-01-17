module.exports = app => {
    const order = require("../controllers/order.mobile.controller.js");
    var router = require("express").Router();
    router.get("/merchant", order.findMerchantOrder);

    router.post("/complete/:id", order.completeDelivery);

    // Get deliveries for a driver (mobile)
    router.get("/my", order.findUserDeliveries);

    // Mark order as complete
    router.get("/driver/:id/status-2", order.findDriverDeliveriesWithStatus);

    app.use('/api/mobile/order', router);
};
