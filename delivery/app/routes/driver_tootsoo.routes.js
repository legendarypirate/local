module.exports = (app) => {
  const controller = require("../controllers/driver_tootsoo.controller.js");
  const router = require("express").Router();
  router.get("/", controller.findAll);
  router.post("/", controller.create);
  router.patch("/:id/status", controller.updateStatus);
  app.use("/api/driver-tootsoos", router);
};
