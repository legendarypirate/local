const db = require("../models");
const DeliveryItem = db.delivery_items;
const Good = db.goods;

/** Statuses where delivery items are already returned to warehouse stock */
const STOCK_RETURNED_STATUSES = new Set([5, 7]);

function isStockReturnedStatus(status) {
  return STOCK_RETURNED_STATUSES.has(Number(status));
}

async function restoreDeliveryItemsStock(deliveryId, transaction) {
  const items = await DeliveryItem.findAll({
    where: { delivery_id: deliveryId },
    transaction,
  });
  for (const item of items) {
    if (!item.good_id) continue;
    await Good.increment(
      { stock: item.quantity },
      { where: { id: item.good_id }, transaction }
    );
  }
}

async function deductDeliveryItemsStock(deliveryId, transaction) {
  const items = await DeliveryItem.findAll({
    where: { delivery_id: deliveryId },
    transaction,
  });
  for (const item of items) {
    if (!item.good_id) continue;
    await Good.increment(
      { stock: -item.quantity },
      { where: { id: item.good_id }, transaction }
    );
  }
}

/** Adjust warehouse stock when delivery status changes */
async function applyStockForStatusChange(oldStatus, newStatus, deliveryId, transaction) {
  const wasReturned = isStockReturnedStatus(oldStatus);
  const isReturned = isStockReturnedStatus(newStatus);
  if (!wasReturned && isReturned) {
    await restoreDeliveryItemsStock(deliveryId, transaction);
  } else if (wasReturned && !isReturned) {
    await deductDeliveryItemsStock(deliveryId, transaction);
  }
}

module.exports = {
  STOCK_RETURNED_STATUSES,
  isStockReturnedStatus,
  restoreDeliveryItemsStock,
  deductDeliveryItemsStock,
  applyStockForStatusChange,
};
