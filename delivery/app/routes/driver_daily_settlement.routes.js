module.exports = (app) => {
  const ctrl = require('../controllers/driver_daily_settlement.controller.js');
  const router = require('express').Router();

  router.get('/', ctrl.list);
  router.post('/payment', ctrl.recordPayment);
  router.post('/sync', ctrl.syncFromReport);

  app.use('/api/driver-daily-settlements', router);
};
