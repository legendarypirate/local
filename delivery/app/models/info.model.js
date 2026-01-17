module.exports = (sequelize, Sequelize) => {
    const Info = sequelize.define("info", {
      richtext: {
        type: Sequelize.STRING
      },
      doctor: {
        type: Sequelize.STRING,
        defaultValue: 0
      },
      image: {
        type: Sequelize.STRING,
        defaultValue: 0
      },
      audio: {
        type: Sequelize.STRING,
        defaultValue: 0
      },
      title: {
        type: Sequelize.STRING,
        defaultValue: 0
      },
      isactive: {
        type: Sequelize.STRING,
        defaultValue: 1
      },
      category: {
        type: Sequelize.STRING,
        defaultValue: 0
      },
      gender: {
        type: Sequelize.STRING,
        defaultValue: 0
      },
      age: {
        type: Sequelize.STRING,
        defaultValue: 0
      },
    
    });
  
    return Info;
  };
  