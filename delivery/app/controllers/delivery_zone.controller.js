const db = require("../models");
const DeliveryZone = db.delivery_zones;
const User = db.users;
const Op = db.Sequelize.Op;

/**
 * Ray-casting point-in-polygon (accurate, works for any simple polygon).
 * @param {number} lat - Point latitude
 * @param {number} lng - Point longitude
 * @param {Array<{lat:number,lng:number}>|Array<[number,number]>} polygon - Closed polygon (array of {lat,lng} or [lat,lng])
 * @returns {boolean}
 */
function pointInPolygon(lat, lng, polygon) {
  if (!polygon || !Array.isArray(polygon) || polygon.length < 3) return false;
  const x = Number(lng);
  const y = Number(lat);
  if (Number.isNaN(x) || Number.isNaN(y)) return false;

  const getLat = (p) => (Array.isArray(p) ? p[0] : p.lat);
  const getLng = (p) => (Array.isArray(p) ? p[1] : p.lng);

  let inside = false;
  const n = polygon.length;
  for (let i = 0, j = n - 1; i < n; j = i++) {
    const xi = getLng(polygon[i]);
    const yi = getLat(polygon[i]);
    const xj = getLng(polygon[j]);
    const yj = getLat(polygon[j]);
    if (yj === yi) continue;
    const intersect = yi > y !== yj > y && x < ((xj - xi) * (y - yi)) / (yj - yi) + xi;
    if (intersect) inside = !inside;
  }
  return inside;
}

/**
 * Find first zone that contains the point. Use when creating delivery to auto-assign driver.
 */
exports.findZoneByPoint = async (lat, lng) => {
  const zones = await DeliveryZone.findAll({
    attributes: ["id", "name", "driver_id", "coordinates"],
    include: [{ model: User, as: "driver", attributes: ["id", "username"] }],
    order: [["id", "ASC"]],
  });
  for (const zone of zones) {
    const coords = zone.coordinates;
    if (pointInPolygon(lat, lng, coords)) {
      return zone;
    }
  }
  return null;
};

/** GET /api/delivery-zone/lookup?lat=&lng= — preview driver for a point */
exports.lookupByPoint = async (req, res) => {
  const lat = parseFloat(req.query.lat, 10);
  const lng = parseFloat(req.query.lng, 10);
  if (Number.isNaN(lat) || Number.isNaN(lng)) {
    return res.status(400).json({ success: false, message: "lat and lng are required" });
  }
  try {
    const zone = await exports.findZoneByPoint(lat, lng);
    if (!zone) {
      return res.json({ success: true, data: null, message: "No zone contains this point" });
    }
    res.json({
      success: true,
      data: {
        zone_id: zone.id,
        zone_name: zone.name,
        driver_id: zone.driver_id,
        driver_username: zone.driver?.username ?? null,
      },
    });
  } catch (err) {
    console.error("delivery_zone lookupByPoint:", err);
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.findAll = async (req, res) => {
  try {
    const data = await DeliveryZone.findAll({
      include: [{ model: User, as: "driver", attributes: ["id", "username"] }],
      order: [["id", "ASC"]],
    });
    res.json({ success: true, data });
  } catch (err) {
    console.error("delivery_zone findAll:", err);
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.findOne = async (req, res) => {
  const id = req.params.id;
  try {
    const zone = await DeliveryZone.findByPk(id, {
      include: [{ model: User, as: "driver", attributes: ["id", "username"] }],
    });
    if (!zone) {
      return res.status(404).json({ success: false, message: "Zone not found" });
    }
    res.json({ success: true, data: zone });
  } catch (err) {
    console.error("delivery_zone findOne:", err);
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.create = async (req, res) => {
  const { name, driver_id, coordinates } = req.body;
  if (!name || driver_id == null) {
    return res.status(400).json({
      success: false,
      message: "name and driver_id are required",
    });
  }
  if (!Array.isArray(coordinates) || coordinates.length < 3) {
    return res.status(400).json({
      success: false,
      message: "coordinates must be an array of at least 3 points (e.g. [{lat, lng}, ...])",
    });
  }
  try {
    const zone = await DeliveryZone.create({
      name,
      driver_id: Number(driver_id),
      coordinates,
    });
    const withDriver = await DeliveryZone.findByPk(zone.id, {
      include: [{ model: User, as: "driver", attributes: ["id", "username"] }],
    });
    res.status(201).json({ success: true, data: withDriver });
  } catch (err) {
    console.error("delivery_zone create:", err);
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.update = async (req, res) => {
  const id = req.params.id;
  const { name, driver_id, coordinates } = req.body;
  try {
    const zone = await DeliveryZone.findByPk(id);
    if (!zone) {
      return res.status(404).json({ success: false, message: "Zone not found" });
    }
    if (name !== undefined) zone.name = name;
    if (driver_id !== undefined) zone.driver_id = Number(driver_id);
    if (coordinates !== undefined) {
      if (!Array.isArray(coordinates) || coordinates.length < 3) {
        return res.status(400).json({
          success: false,
          message: "coordinates must be an array of at least 3 points",
        });
      }
      zone.coordinates = coordinates;
    }
    await zone.save();
    const withDriver = await DeliveryZone.findByPk(zone.id, {
      include: [{ model: User, as: "driver", attributes: ["id", "username"] }],
    });
    res.json({ success: true, data: withDriver });
  } catch (err) {
    console.error("delivery_zone update:", err);
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.delete = async (req, res) => {
  const id = req.params.id;
  try {
    const n = await DeliveryZone.destroy({ where: { id } });
    if (n === 0) {
      return res.status(404).json({ success: false, message: "Zone not found" });
    }
    res.json({ success: true, message: "Zone deleted" });
  } catch (err) {
    console.error("delivery_zone delete:", err);
    res.status(500).json({ success: false, message: err.message });
  }
};
