"use strict";

/**
 * Нэг дэлгүүрийн давхардсан хэрэглэгч: бүх merchant_id 169 → 170,
 * дараа нь users.id = 169 устгана (NLO давхар бүртгэл).
 *
 * Ажиллуулах: delivery хавтасаас `npx sequelize-cli db:migrate` (эсвэл өөрийн deploy pipeline).
 * Буцаах боломжгүй — шаардлагатай бол DB backup аваарай.
 */
const FROM_MERCHANT_USER_ID = 169;
const TO_MERCHANT_USER_ID = 170;

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface) {
    const { sequelize } = queryInterface;
    const t = await sequelize.transaction();
    const rep = { from: FROM_MERCHANT_USER_ID, to: TO_MERCHANT_USER_ID };

    const run = async (sql) => {
      await sequelize.query(sql, { replacements: rep, transaction: t });
    };

    try {
      const tables = await queryInterface.showAllTables();
      const hasTable = (name) =>
        tables.some((x) => String(x).toLowerCase() === name.toLowerCase());

      await run(
        `UPDATE deliveries SET merchant_id = :to WHERE merchant_id = :from`
      );
      await run(`UPDATE orders SET merchant_id = :to WHERE merchant_id = :from`);
      await run(`UPDATE goods SET merchant_id = :to WHERE merchant_id = :from`);
      await run(`UPDATE histories SET merchant_id = :to WHERE merchant_id = :from`);
      await run(`UPDATE summaries SET merchant_id = :to WHERE merchant_id = :from`);
      await run(`UPDATE requests SET merchant_id = :to WHERE merchant_id = :from`);

      if (hasTable("words")) {
        await run(`UPDATE words SET merchant_id = :to WHERE merchant_id = :from`);
      }

      await run(
        `UPDATE delivery_address_requests SET requested_by_user_id = :to WHERE requested_by_user_id = :from`
      );
      await run(
        `UPDATE delivery_address_requests SET new_driver_id = :to WHERE new_driver_id = :from`
      );
      await run(
        `UPDATE delivery_not_picked_requests SET requested_by_user_id = :to WHERE requested_by_user_id = :from`
      );

      // Хэрэв 169 нь delivery_zones.driver_id дээр үлдсэн бол users устгахад FK саатана
      await run(
        `UPDATE delivery_zones SET driver_id = :to WHERE driver_id = :from`
      );

      await sequelize.query(`DELETE FROM users WHERE id = :from`, {
        replacements: { from: FROM_MERCHANT_USER_ID },
        transaction: t,
      });

      await t.commit();
    } catch (e) {
      await t.rollback();
      throw e;
    }
  },

  async down() {
    throw new Error(
      "merge-merchant-169-into-170: буцаах боломжгүй (хэрэглэгч 169 устгагдсан). Backup-аас сэргээнэ үү."
    );
  },
};
