module.exports = (app) => {
  const ctrl = require("../controllers/delivery_address_request.controller.js");
  const router = require("express").Router();

  router.get("/", ctrl.findAllForAdmin);
  router.put("/:id/approve", ctrl.approve);
  router.put("/:id/reject", ctrl.reject);

  app.use("/api/delivery-address-requests", router);
};
