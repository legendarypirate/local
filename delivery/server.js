const express = require("express");
const cors = require("cors");
const path = require("path");

const app = express();

// CORS configuration to allow only a specific origin
var corsOptions = {
  origin: "https://localexpress.mn"
};

// Enable CORS
app.use(cors(corsOptions));

// parse requests of content-type - application/json
app.use(express.json());

// parse requests of content-type - application/x-www-form-urlencoded
app.use(express.urlencoded({ extended: true }));

// Serve static files (images) from the 'app/assets' folder
app.use("/assets", express.static(path.join(__dirname, "app", "assets")));

// Import models (Make sure to update the path if necessary)y
const db = require("./app/models");

// Sync database and handle any errors
db.sequelize.sync()
  .then(() => {
    console.log("Synced db.");
  })
  .catch((err) => {
    console.log("Failed to sync db: " + err.message);
  });

// simple route
app.get("/", (req, res) => {
  res.json({ message: "Welcome to the application." });
});
require("./app/routes/ware.routes")(app);

require("./app/routes/good.routes")(app);

// Route imports
require("./app/routes/age.routes")(app);
require("./app/routes/doctor.routes")(app);
require("./app/routes/info.routes")(app);
require("./app/routes/delivery.routes")(app);
require("./app/routes/status.routes")(app);
require("./app/routes/order.routes")(app);
require("./app/routes/region.routes")(app);
require("./app/routes/notification.routes")(app);
require("./app/routes/report.routes")(app);
require("./app/routes/summary.routes")(app);
require("./app/routes/request.routes")(app);

// Route imports
require("./app/routes/banner.routes")(app);
require("./app/routes/product.routes")(app);
require("./app/routes/auth.routes")(app);

// Role-related routes
require("./app/routes/role.routes")(app);
require("./app/routes/permission.routes")(app);

// Word-related routes
require("./app/routes/word.routes")(app);

// Category-related routes
require("./app/routes/category.routes")(app);
require("./app/routes/privacy.routes")(app);
require("./app/routes/rolePermission.routes")(app);


// User-related routes
require("./app/routes/user.routes")(app);
//mobile
require("./app/routes/delivery.mobile.routes")(app);
require("./app/routes/order.mobile.routes")(app);
require("./app/routes/good.mobile.routes")(app);

// Add error handling for undefined routes
app.all('*', (req, res) => {
  res.status(404).json({ message: "Route not found!" });
});

// set port, listen for requests
const PORT = process.env.PORT || 3003;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}.`);
});
