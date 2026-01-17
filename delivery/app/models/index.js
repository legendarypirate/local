const dbConfig = require("../config/db.config.js");

const Sequelize = require("sequelize");
const sequelize = new Sequelize(dbConfig.DB, dbConfig.USER, dbConfig.PASSWORD, {
  host: dbConfig.HOST,
  dialect: dbConfig.dialect,

  pool: {
    max: dbConfig.pool.max,
    min: dbConfig.pool.min,
    acquire: dbConfig.pool.acquire,
    idle: dbConfig.pool.idle
  }
});

const db = {};

db.Sequelize = Sequelize;
db.sequelize = sequelize;
db.roles = require("./role.model.js")(sequelize, Sequelize);
db.infos = require("./info.model.js")(sequelize, Sequelize);
db.deliveries = require("./delivery.model.js")(sequelize, Sequelize);

db.Categories = require("./category.model.js")(sequelize, Sequelize);
db.users = require("./user.model.js")(sequelize, Sequelize);
db.words = require("./word.model.js")(sequelize, Sequelize);
db.products = require("./product.model.js")(sequelize, Sequelize);
db.banners = require("./banner.model.js")(sequelize, Sequelize);
db.productImages = require("./productImage.model.js")(sequelize, Sequelize);
db.ages = require("./age.model.js")(sequelize, Sequelize);
db.doctors = require("./doctor.model.js")(sequelize, Sequelize);
db.profiles = require("./profile.model.js")(sequelize, Sequelize);
db.privacies = require("./privacy.model.js")(sequelize, Sequelize);
db.statuses = require("./status.model.js")(sequelize, Sequelize);
db.orders = require("./order.model.js")(sequelize, Sequelize);
db.regions = require("./region.model.js")(sequelize, Sequelize);
db.notifications = require("./notification.model.js")(sequelize, Sequelize);
db.logs = require("./log.model.js")(sequelize, Sequelize);
db.summaries = require("./summary.model.js")(sequelize, Sequelize);
db.permissions = require("./permission.model.js")(sequelize, Sequelize);
db.wares = require("./ware.model.js")(sequelize, Sequelize);
db.goods = require("./good.model.js")(sequelize, Sequelize);
db.requests = require("./request.model.js")(sequelize, Sequelize);
db.delivery_items = require("./delivery_item.model.js")(sequelize, Sequelize);

db.histories = require("./history.model.js")(sequelize, Sequelize);

db.role_permissions = require("./role_permission.model.js")(sequelize, Sequelize);

db.histories.belongsTo(db.users, {
  foreignKey: 'driver_id',
  as: 'driver'
});

// History belongs to Status
db.histories.belongsTo(db.statuses, {
  foreignKey: 'status',
  as: 'status_name'
});

// User has many Histories (optional)
db.users.hasMany(db.histories, {
  foreignKey: 'driver_id',
  as: 'histories'
});

// Status has many Histories (optional)
db.statuses.hasMany(db.histories, {
  foreignKey: 'status',
  as: 'histories'
});

db.roles.belongsToMany(db.permissions, {
  through: db.role_permissions,
  foreignKey: 'role_id',
  otherKey: 'permission_id',
  as: 'permissions',  // alias for eager loading roles with permissions
});

db.permissions.belongsToMany(db.roles, {
  through: db.role_permissions,
  foreignKey: 'permission_id',
  otherKey: 'role_id',
  as: 'roles',  // alias for eager loading permissions with roles
});

// Add belongsTo associations on role_permissions to allow eager loading
db.role_permissions.belongsTo(db.roles, { foreignKey: 'role_id' });
db.role_permissions.belongsTo(db.permissions, { foreignKey: 'permission_id' });
//aguulahiin baraa

// Good belongs to a merchant (User)
db.users.hasMany(db.goods, {
  foreignKey: 'merchant_id',
  as: 'goods', // user.goods
});

db.goods.belongsTo(db.users, {
  foreignKey: 'merchant_id',
  as: 'merchant', // good.merchant
});




db.deliveries.hasMany(db.delivery_items, {
  foreignKey: 'delivery_id',
  as: 'items', // delivery.items
});

// DeliveryItem belongs to a Delivery
db.delivery_items.belongsTo(db.deliveries, {
  foreignKey: 'delivery_id',
  as: 'delivery', // item.delivery
});



// Good has many DeliveryItems
db.goods.hasMany(db.delivery_items, {
  foreignKey: 'good_id',
  as: 'delivery_items', // good.delivery_items
});

// DeliveryItem belongs to a Good (optional, since some may be null)
db.delivery_items.belongsTo(db.goods, {
  foreignKey: 'good_id',
  as: 'good', // item.good
});



// Good belongs to a warehouse (Ware)
db.wares.hasMany(db.goods, {
  foreignKey: 'ware_id',
  as: 'goods', // ware.goods
});

db.goods.belongsTo(db.wares, {
  foreignKey: 'ware_id',
  as: 'ware', // good.ware
});




db.users.hasMany(db.requests, {
  foreignKey: 'merchant_id',
  as: 'requests', // user.goods
});

db.requests.belongsTo(db.users, {
  foreignKey: 'merchant_id',
  as: 'merchant', // good.merchant
});

db.goods.hasMany(db.requests, {
  foreignKey: 'good_id',
  as: 'requests', // user.goods
});

db.requests.belongsTo(db.goods, {
  foreignKey: 'good_id',
  as: 'good', // good.merchant
});


// Good belongs to a warehouse (Ware)
db.wares.hasMany(db.requests, {
  foreignKey: 'ware_id',
  as: 'requests', // ware.goods
});

db.requests.belongsTo(db.wares, {
  foreignKey: 'ware_id',
  as: 'ware', // good.ware
});



// Association between Users and Deliveries (Already defined)
db.users.hasMany(db.orders, {
  foreignKey: 'merchant_id',
  as: 'orders', // optional alias for user.deliveries
});

db.orders.belongsTo(db.users, {
  foreignKey: 'merchant_id',
  as: 'merchant', // optional alias for delivery.merchant
});

db.users.hasMany(db.orders, {
  foreignKey: 'driver_id',
  as: 'driver_orders', // optional alias for user.deliveries as a driver
});

db.orders.belongsTo(db.users, {
  foreignKey: 'driver_id',
  as: 'driver', // this allows delivery.driver to access the User (driver) info
});


//summary vs users

db.users.hasMany(db.summaries, {
  foreignKey: 'merchant_id',
  as: 'summaries', // optional alias for user.deliveries
});

db.summaries.belongsTo(db.users, {
  foreignKey: 'merchant_id',
  as: 'merchant', // optional alias for delivery.merchant
});

db.users.hasMany(db.summaries, {
  foreignKey: 'driver_id',
  as: 'driver_summaries', // optional alias for user.deliveries as a driver
});

db.summaries.belongsTo(db.users, {
  foreignKey: 'driver_id',
  as: 'driver_summaries', // this allows delivery.driver to access the User (driver) info
});




// Association between Users and Deliveries (Already defined)
db.users.hasMany(db.deliveries, {
  foreignKey: 'merchant_id',
  as: 'deliveries', // optional alias for user.deliveries
});

db.deliveries.belongsTo(db.users, {
  foreignKey: 'merchant_id',
  as: 'merchant', // optional alias for delivery.merchant
});

// New Association: Status and Deliveries
db.statuses.hasMany(db.deliveries, {
  foreignKey: 'status',
  as: 'deliveries', // optional alias for status.deliveries
});

db.deliveries.belongsTo(db.statuses, {
  foreignKey: 'status',
  as: 'status_name', // optional alias for delivery.status
});
// Driver Association: One User (as Driver) has many Deliveries
db.users.hasMany(db.deliveries, {
  foreignKey: 'driver_id',
  as: 'driver_deliveries', // optional alias for user.deliveries as a driver
});

db.deliveries.belongsTo(db.users, {
  foreignKey: 'driver_id',
  as: 'driver', // this allows delivery.driver to access the User (driver) info
});


module.exports = db;
