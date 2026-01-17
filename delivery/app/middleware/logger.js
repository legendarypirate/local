// middleware/logger.js
const { Log } = require('../models');

const loggerMiddleware = async (req, res, next) => {
  const { method, originalUrl, body, user } = req;

  res.on('finish', async () => {
    try {
      await Log.create({
        action: method,
        table: originalUrl,
        userId: user?.id || null,
        values: JSON.stringify(body), // make sure to store it as JSON string
      });
    } catch (err) {
      console.error('Logging error:', err);
    }
  });

  next();
};

module.exports = loggerMiddleware;
