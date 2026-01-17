const db = require("../models");
const Order = db.orders;
const Op = db.Sequelize.Op;
const User = db.users;
const Status = db.statuses;

exports.findDriverDeliveriesWithStatus = (req, res) => {
    const driverId = req.params.id;
  
    Order.findAll({
      where: {
        driver_id: driverId,
        status: 2
      },
      include: [
        {
          model: User,
          as: 'merchant',
          attributes: ['username'],
        }
      ]
    })
    .then(data => {
      const result = data.map(order => {
        return {
          ...order.toJSON(),
          status_text: "Жолоочид хуваарилсан"
        };
      });
  
      res.send({
        success: true,
        data: result
      });
    })
    .catch(err => {
      res.status(500).send({
        message: err.message || "Some error occurred while retrieving deliveries."
      });
    });
  };
  

  exports.findMerchantOrder = (req, res) => {
    const userId = req.query.user_id;
  
    if (!userId) {
      return res.status(400).send({ success: false, message: "Missing user_id" });
    }
  
    Order.findAll({ where: { merchant_id: userId } })
      .then(data => res.send({ success: true, data }))
      .catch(err =>
        res.status(500).send({ success: false, message: err.message })
      );
  };

exports.findUserDeliveries = (req, res) => {
    const userId = req.query.user_id;
    Order.findAll({ where: { driver_id: userId } })
        .then(data => res.send(data))
        .catch(err => res.status(500).send({ message: err.message }));
};

exports.completeDelivery = (req, res) => {
    const id = req.params.id;
    const { status } = req.body;

    if (!status) {
        return res.status(400).send({
            success: false,
            message: "Status is required."
        });
    }

    Order.update({ status }, { where: { id } })
        .then(num => {
            if (num == 1) {
                res.send({
                    success: true,
                    data: { message: "Delivery status updated to " + status }
                });
            } else {
                res.status(404).send({
                    success: false,
                    message: "Delivery not found."
                });
            }
        })
        .catch(err => {
            res.status(500).send({
                success: false,
                message: err.message
            });
        });
};

