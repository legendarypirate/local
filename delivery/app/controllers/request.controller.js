const db = require("../models");
const Request = db.requests;
const User = db.users;
const Ware = db.wares;
const Good = db.goods;


exports.createRequest = async (req, res) => {
    const { type, amount, ware_id, merchant_id, good_id, name, stock } = req.body;
    const amountNum = amount != null ? Number(amount) : (stock != null ? Number(stock) : null);

    if (![1, 2, 3].includes(Number(type))) {
      return res.status(400).json({ success: false, message: "Invalid 'type'. Must be 1, 2, or 3." });
    }

    if (amountNum == null || isNaN(amountNum) || amountNum <= 0) {
      return res.status(400).json({ success: false, message: "Invalid 'amount'. Must be a positive number." });
    }

    if (!ware_id || !merchant_id) {
      return res.status(400).json({ success: false, message: "'ware_id' and 'merchant_id' are required." });
    }

    if (Number(type) === 1 && !name) {
      return res.status(400).json({ success: false, message: "'name' is required for type 1 (create good)." });
    }

    if ((Number(type) === 2 || Number(type) === 3) && (good_id == null || good_id === '')) {
      return res.status(400).json({ success: false, message: "'good_id' is required for types 2 and 3." });
    }

    try {
      const newRequest = await Request.create({
        type: Number(type),
        stock: Math.floor(amountNum),
        status: 1,
        ware_id: Number(ware_id),
        good_id: good_id != null && good_id !== '' ? Number(good_id) : null,
        merchant_id: Number(merchant_id),
        name: name || null,
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
        message: error.message || "Error creating request.",
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

  // Approve request (optional body.stock = approved amount to use; defaults to request.stock)
  exports.approve = async (req, res) => {
    const requestId = req.params.id;
    const bodyStock = req.body && req.body.stock != null ? Number(req.body.stock) : null;
    const approvedAmount = bodyStock != null && !isNaN(bodyStock) && bodyStock > 0
      ? Math.floor(bodyStock)
      : null;

    try {
      const request = await Request.findByPk(requestId);

      if (!request) {
        return res.status(404).json({ success: false, message: 'Request not found.' });
      }

      if (request.status !== 1) {
        return res.status(400).json({ success: false, message: 'Only pending requests can be approved.' });
      }

      const amountToUse = approvedAmount != null ? approvedAmount : request.stock;
      const updatePayload = { status: 2 };
      if (approvedAmount != null) updatePayload.approved_stock = approvedAmount;

      if (request.type === 1) {
        await Good.create({
          name: request.name,
          stock: amountToUse,
          merchant_id: request.merchant_id,
          ware_id: request.ware_id,
        });
      } else if (request.type === 2) {
        const good = await Good.findByPk(request.good_id);
        if (!good) {
          return res.status(404).json({ success: false, message: 'Good not found.' });
        }
        await good.update({ stock: good.stock + amountToUse });
      } else if (request.type === 3) {
        const good = await Good.findByPk(request.good_id);
        if (!good) {
          return res.status(404).json({ success: false, message: 'Good not found.' });
        }
        if (good.stock < amountToUse) {
          return res.status(400).json({ success: false, message: 'Not enough stock to reduce.' });
        }
        await good.update({ stock: good.stock - amountToUse });
      }

      await request.update(updatePayload);
      return res.json({ success: true, message: 'Request approved and processed successfully.', data: request });
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
  

// Find all (order by newest first; optional merchant_id filter)
exports.findAll = async (req, res) => {
    const merchantIdParam = req.query.merchant_id;
    const merchantId = merchantIdParam != null ? parseInt(merchantIdParam, 10) : null;
    const condition = merchantId != null && !isNaN(merchantId) ? { merchant_id: merchantId } : undefined;

    try {
      const data = await Request.findAll({
        where: condition,
        order: [['createdAt', 'DESC']],
        include: [
          { model: User, as: 'merchant', attributes: ['id', 'username'] },
          { model: Ware, as: 'ware', attributes: ['id', 'name'] },
          {
            model: Good,
            as: 'good',
            attributes: ['id', 'name'],
            required: false,
          },
        ],
      });
      res.json({ success: true, data });
    } catch (err) {
      console.error('Error listing requests:', err);
      res.status(500).json({
        success: false,
        message: err.message || "Error retrieving requests.",
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
