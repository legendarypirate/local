module.exports = (app) => {
  const controller = require("../controllers/delivery_zone.controller.js");
  const router = require("express").Router();

  router.get("/", controller.findAll);
  router.get("/:id", controller.findOne);
  router.post("/", controller.create);
  router.put("/:id", controller.update);
  router.delete("/:id", controller.delete);

  app.use("/api/delivery-zone", router);
};
