module.exports = (sequelize, Sequelize) => {
    const Privacy = sequelize.define("privacy", {
        privacy: {
        type: Sequelize.STRING
      },
    
    
    });
  
    return Privacy;
  };
  