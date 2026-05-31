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
db.khoroos = require("./khoroo.model.js")(sequelize, Sequelize);
db.notifications = require("./notification.model.js")(sequelize, Sequelize);
db.logs = require("./log.model.js")(sequelize, Sequelize);
db.summaries = require("./summary.model.js")(sequelize, Sequelize);
db.permissions = require("./permission.model.js")(sequelize, Sequelize);
db.wares = require("./ware.model.js")(sequelize, Sequelize);
db.goods = require("./good.model.js")(sequelize, Sequelize);
db.requests = require("./request.model.js")(sequelize, Sequelize);
db.delivery_items = require("./delivery_item.model.js")(sequelize, Sequelize);

db.histories = require("./history.model.js")(sequelize, Sequelize);
db.driver_tootsoos = require("./driver_tootsoo.model.js")(sequelize, Sequelize);
db.delivery_zones = require("./delivery_zone.model.js")(sequelize, Sequelize);
db.delivery_address_requests = require("./delivery_address_request.model.js")(sequelize, Sequelize);
db.delivery_not_picked_requests = require("./delivery_not_picked_request.model.js")(sequelize, Sequelize);
db.delivery_price_settings = require("./delivery_price_setting.model.js")(sequelize, Sequelize);
db.driver_daily_settlements = require("./driver_daily_settlement.model.js")(sequelize, Sequelize);
db.driver_settlement_payments = require("./driver_settlement_payment.model.js")(sequelize, Sequelize);
db.service_regions = require("./service_region.model.js")(sequelize, Sequelize);
db.service_region_khoroos = require("./service_region_khoroo.model.js")(sequelize, Sequelize);

db.role_permissions = require("./role_permission.model.js")(sequelize, Sequelize);

db.driver_daily_settlements.belongsTo(db.users, {
  foreignKey: 'driver_id',
  as: 'driver',
});
db.users.hasMany(db.driver_daily_settlements, {
  foreignKey: 'driver_id',
  as: 'daily_settlements',
});
db.driver_daily_settlements.hasMany(db.driver_settlement_payments, {
  foreignKey: 'settlement_id',
  as: 'payments',
});
db.driver_settlement_payments.belongsTo(db.driver_daily_settlements, {
  foreignKey: 'settlement_id',
  as: 'settlement',
});

db.deliveries.belongsTo(db.delivery_price_settings, {
  foreignKey: 'price_setting_id',
  as: 'price_setting',
});
db.delivery_price_settings.hasMany(db.deliveries, {
  foreignKey: 'price_setting_id',
  as: 'deliveries',
});

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

db.deliveries.hasMany(db.delivery_address_requests, {
  foreignKey: 'delivery_id',
  as: 'address_requests',
});
db.delivery_address_requests.belongsTo(db.deliveries, {
  foreignKey: 'delivery_id',
  as: 'delivery',
});
db.delivery_address_requests.belongsTo(db.users, {
  foreignKey: 'requested_by_user_id',
  as: 'requester',
});
db.delivery_address_requests.belongsTo(db.users, {
  foreignKey: 'new_driver_id',
  as: 'new_driver',
});

db.deliveries.hasMany(db.delivery_not_picked_requests, {
  foreignKey: 'delivery_id',
  as: 'not_picked_requests',
});
db.delivery_not_picked_requests.belongsTo(db.deliveries, {
  foreignKey: 'delivery_id',
  as: 'delivery',
});
db.delivery_not_picked_requests.belongsTo(db.users, {
  foreignKey: 'requested_by_user_id',
  as: 'requester',
});

// DriverTootsoo (driver_tootsoos) belongs to User (driver)
db.driver_tootsoos.belongsTo(db.users, {
  foreignKey: 'driver_id',
  as: 'driver',
});
db.users.hasMany(db.driver_tootsoos, {
  foreignKey: 'driver_id',
  as: 'driver_tootsoos',
});

// Region and Khoroo associations
db.regions.hasMany(db.khoroos, {
  foreignKey: 'region_id',
  as: 'khoroos', // region.khoroos
});

db.khoroos.belongsTo(db.regions, {
  foreignKey: 'region_id',
  as: 'region', // khoroo.region
});

// Delivery and Khoroo associations
db.khoroos.hasMany(db.deliveries, {
  foreignKey: 'khoroo_id',
  as: 'deliveries', // khoroo.deliveries
});

db.deliveries.belongsTo(db.khoroos, {
  foreignKey: 'khoroo_id',
  as: 'khoroo', // delivery.khoroo
});

db.deliveries.belongsTo(db.service_regions, {
  foreignKey: 'service_region_id',
  as: 'service_region',
});
db.service_regions.hasMany(db.deliveries, {
  foreignKey: 'service_region_id',
  as: 'deliveries',
});

db.delivery_zones.belongsTo(db.users, { foreignKey: 'driver_id', as: 'driver' });
db.users.hasMany(db.delivery_zones, { foreignKey: 'driver_id', as: 'delivery_zones' });

db.service_regions.belongsTo(db.users, { foreignKey: 'driver_id', as: 'driver' });
db.users.hasMany(db.service_regions, { foreignKey: 'driver_id', as: 'service_regions' });
db.service_regions.belongsToMany(db.khoroos, {
  through: db.service_region_khoroos,
  foreignKey: 'service_region_id',
  otherKey: 'khoroo_id',
  as: 'khoroos',
});
db.khoroos.belongsToMany(db.service_regions, {
  through: db.service_region_khoroos,
  foreignKey: 'khoroo_id',
  otherKey: 'service_region_id',
  as: 'service_regions',
});

module.exports = db;
