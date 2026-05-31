module.exports = (app) => {
  const ctrl = require('../controllers/delivery_price_setting.controller.js');
  const router = require('express').Router();

  router.get('/', ctrl.findAll);
  router.post('/', ctrl.create);
  router.put('/:id', ctrl.update);
  router.delete('/:id', ctrl.remove);

  app.use('/api/delivery-price-settings', router);
};
