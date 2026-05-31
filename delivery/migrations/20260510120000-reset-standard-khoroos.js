'use strict';

const { seedStandardKhoroos } = require('../app/utils/standard_khoroos');

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up() {
    await seedStandardKhoroos();
  },

  async down() {
    // irreversible data reset
  },
};
