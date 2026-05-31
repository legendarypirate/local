module.exports = (app) => {
  const ctrl = require('../controllers/service_region.controller.js');
  const router = require('express').Router();

  router.get('/khoroos-grouped', ctrl.khoroosGrouped);
  router.get('/lookup', ctrl.lookup);
  router.get('/', ctrl.list);
  router.post('/', ctrl.create);
  router.put('/:id', ctrl.update);
  router.put('/:id/khoroos', ctrl.setKhoroos);
  router.delete('/:id', ctrl.delete);

  app.use('/api/service-region', router);
};
