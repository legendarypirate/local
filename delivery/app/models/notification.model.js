module.exports = (sequelize, Sequelize) => {
    const Notification = sequelize.define("notification", {
      title: {
        type: Sequelize.STRING
      },
      body: {
        type: Sequelize.STRING
      },
      type: {
        type: Sequelize.INTEGER
      }
   
    });
  
    return Notification;
};
  