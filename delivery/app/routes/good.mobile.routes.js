module.exports = app => {
    const good = require("../controllers/good.mobile.controller.js");
    var router = require("express").Router();
    router.get("/merchant", good.findMerchantGood);

    router.post("/complete/:id", good.completeDelivery);

    // Get deliveries for a driver (mobile)
    router.get("/my", good.findUserDeliveries);

    // Mark order as complete
    router.get("/driver/:id/status-2", good.findDriverDeliveriesWithStatus);

    app.use('/api/mobile/good', router);
};
