const db = require("../models");
const Request = db.requests;
const User = db.users;
const Ware = db.wares;
const Good = db.goods;


exports.createRequest = async (req, res) => {
    const { type, amount, ware_id, merchant_id, good_id, name, stock } = req.body;
  
    // Validate type
    if (![1, 2, 3].includes(type)) {
      return res.status(400).json({ success: false, message: "Invalid 'type'. Must be 1, 2, or 3." });
    }
  
    if (typeof amount !== 'number' || amount <= 0) {
      return res.status(400).json({ success: false, message: "Invalid 'amount'. Must be positive." });
    }
  
    if (!ware_id || !merchant_id) {
      return res.status(400).json({ success: false, message: "'ware_id' and 'merchant_id' are required." });
    }
  
    // For type 1 (create), 'name' and 'stock' may be needed
    if (type === 1 && (!name || typeof amount !== 'number')) {
      return res.status(400).json({ success: false, message: "'name' and 'stock' required for type 1." });
    }
  
    // For type 2 and 3, good_id is required
    if ((type === 2 || type === 3) && !good_id) {
      return res.status(400).json({ success: false, message: "'good_id' is required for types 2 and 3." });
    }
  
    try {
      const newRequest = await Request.create({
        type:type,
        stock: amount,
        status: 1,
        ware_id,
        good_id:good_id ,
        merchant_id,
        name, // for create type
      });
  
      return res.status(201).json({
        success: true,
        message: "Request created successfully.",
        data: newRequest,
      });
    } catch (error) {
      console.error('Error creating request:', error);
      return res.status(500).json({
        success: false,
        message: "Error creating request.",
        error: error.message,
      });
    }
  };
  
// Create
exports.create = (req, res) => {
    // Validate request
    if (!req.body.ware_id) {
      res.status(400).send({
        message: "Content can not be empty!"
      });
      return;
    }
  
    // Create a Categories
    const cat = {
        ware_id: req.body.ware_id,
        merchant_id:req.body.merchant_id,
        stock:req.body.stock,
        status:1,
        name:req.body.name,
        type:1
    };
  
    // Save Categories in the database
    Request.create(cat)
    .then(data => {
      res.json({ success: true, data: data });
    })
    .catch(err => {
      res.status(500).json({ success: false, message: err.message || "Some error occurred while creating the Banner." });
    });
  };

  // Approve request
  exports.approve = async (req, res) => {
    const requestId = req.params.id;
  
    try {
      const request = await Request.findByPk(requestId);
  
      if (!request) {
        return res.status(404).json({ success: false, message: 'Request not found.' });
      }
  
      // Update status to approved
      await request.update({ status: 2 });
  
      // Process based on type
      if (request.type === 1) {
        // Type 1: Create new good
        await Good.create({
          name: request.name,
          stock: request.stock,
          merchant_id: request.merchant_id,
          ware_id: request.ware_id,
        });
  
      } else if (request.type === 2) {
        // Type 2: Add stock to existing good
        const good = await Good.findByPk(request.good_id);
        if (!good) {
          return res.status(404).json({ success: false, message: 'Good not found.' });
        }
        await good.update({ stock: good.stock + request.stock });
  
      } else if (request.type === 3) {
        // Type 3: Reduce stock from existing good
        const good = await Good.findByPk(request.good_id);
        if (!good) {
          return res.status(404).json({ success: false, message: 'Good not found.' });
        }
  
        if (good.stock < request.stock) {
          return res.status(400).json({ success: false, message: 'Not enough stock to reduce.' });
        }
  
        await good.update({ stock: good.stock - request.stock });
      }
  
      return res.json({ success: true, message: 'Request approved and processed successfully.' });
  
    } catch (err) {
      console.error('Approve error:', err);
      return res.status(500).json({ success: false, message: err.message });
    }
  };
  // Decline request
  exports.decline = async (req, res) => {
    try {
      const [updated] = await Request.update(
        { status: 3 }, // declined
        { where: { id: req.params.id } }
      );
      if (updated) {
        res.json({ success: true, message: 'Request declined.' });
      } else {
        res.status(404).json({ success: false, message: 'Request not found.' });
      }
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  };
  

// Find all
exports.findAll = async (req, res) => {
    const merchant_id = req.query.merchant_id;
  
    // Build condition only if merchant_id exists
    const condition = merchant_id ? { merchant_id: merchant_id } : undefined;
  
    try {
      const data = await Request.findAll({
        where: condition,
        include: [
          {
            model: User,
            as: 'merchant',
            attributes: ['id', 'username'],
          },
          {
            model: Ware,
            as: 'ware',
            attributes: ['id', 'name'],
          },
          {
            model: Good,
            as: 'good',
            attributes: ['id', 'name'],
            required: false, // allows type 1 to not fail when good_id is null
          },
        ],
      });
  
      res.send({
        success: true,
        data,
      });
    } catch (err) {
      res.status(500).send({
        success: false,
        message: err.message || "Some error occurred while retrieving requests.",
      });
    }
  };
  

// Find one
exports.findOne = async (req, res) => {
  try {
    const data = await Request.findByPk(req.params.id);
    if (data) res.json({ success: true, data });
    else res.status(404).json({ success: false, message: "Not found" });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// Update
exports.update = async (req, res) => {
  try {
    const [updated] = await Request.update(req.body, {
      where: { id: req.params.id }
    });
    if (updated) res.json({ success: true });
    else res.status(404).json({ success: false, message: "Not found" });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// Delete one
exports.delete = async (req, res) => {
  try {
    const deleted = await Request.destroy({
      where: { id: req.params.id }
    });
    if (deleted) res.json({ success: true });
    else res.status(404).json({ success: false, message: "Not found" });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// Delete all
exports.deleteAll = async (req, res) => {
  try {
    const deleted = await Request.destroy({ where: {}, truncate: false });
    res.json({ success: true, deleted });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};
