module.exports = (sequelize, Sequelize) => {
    const Category = sequelize.define("category", {
      name: {
        type: Sequelize.STRING
      },
      address1: {
        type: Sequelize.STRING
      },
      address2: {
        type: Sequelize.STRING
      },
      city: {
        type: Sequelize.STRING
      },
      state: {
        type: Sequelize.STRING
      },
      phone: {
        type: Sequelize.STRING
      },
      website: {
        type: Sequelize.STRING
      },
      email: {
        type: Sequelize.STRING
      },
      zipcode: {
        type: Sequelize.STRING
      },
      country: {
        type: Sequelize.STRING
      },
      nature: {
        type: Sequelize.STRING
      },
      brand: {
        type: Sequelize.STRING
      },
      lookfor: {
        type: Sequelize.STRING
      },
      area: {
        type: Sequelize.STRING
      },
      size: {
        type: Sequelize.STRING
      },
      request: {
        type: Sequelize.STRING
      },
    });
  
    return Category;
  };
  