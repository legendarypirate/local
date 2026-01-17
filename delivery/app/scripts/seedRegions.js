// seedRegions.js
// This script ensures that all districts exist in the regions table with the correct IDs

const db = require("../models");
const Region = db.regions;

const districts = [
  { id: 1, name: 'Баянзүрх' },
  { id: 2, name: 'Хан-Уул' },
  { id: 3, name: 'Сүхбаатар' },
  { id: 4, name: 'Чингэлтэй' },
  { id: 5, name: 'Сонгинохайрхан' },
  { id: 6, name: 'Баянгол' }
];

(async () => {
  try {
    console.log('🌱 Seeding regions (districts)...\n');

    for (const district of districts) {
      // Check if region with this ID exists
      const existing = await Region.findByPk(district.id);

      if (existing) {
        // Update name if it's different
        if (existing.name !== district.name) {
          await existing.update({ name: district.name });
          console.log(`🔄 Updated region: ID ${district.id} - ${district.name}`);
        } else {
          console.log(`✔️ Already exists: ID ${district.id} - ${district.name}`);
        }
      } else {
        // Create new region with specific ID
        // Note: This requires the sequence to allow manual ID insertion
        await Region.create({
          id: district.id,
          name: district.name
        });
        console.log(`✅ Created region: ID ${district.id} - ${district.name}`);
      }
    }

    console.log('\n✨ Region seeding completed!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error seeding regions:', error.message);
    process.exit(1);
  }
})();

