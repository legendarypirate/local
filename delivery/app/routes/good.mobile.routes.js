module.exports = (app) => {
  const good = require("../controllers/good.mobile.controller.js");
  const multer = require("multer");
  const upload = multer({
    storage: multer.memoryStorage(),
    limits: { fileSize: 10 * 1024 * 1024 },
  });
  const router = require("express").Router();

  router.get("/merchant", good.findMerchantGood);
  router.put("/:id/image", upload.single("image"), good.uploadGoodImage);

  app.use("/api/mobile/good", router);
};
