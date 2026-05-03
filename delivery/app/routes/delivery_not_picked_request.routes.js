module.exports = (app) => {
  const ctrl = require("../controllers/delivery_not_picked_request.controller.js");
  const router = require("express").Router();

  router.get("/", ctrl.findAllForAdmin);
  router.put("/:id/approve", ctrl.approve);
  router.put("/:id/reject", ctrl.reject);

  app.use("/api/delivery-not-picked-requests", router);
};
