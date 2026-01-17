// seedPermissions.js

const db = require("../models");
const Permission = db.permissions;
const modules = ['delivery', 'order', 'product','good','user','settings','role','warehouse','status','log','dashboard','region','notification','reports'];
const actions = ['create', 'view', 'update', 'delete','allocate','excel_import','manage'];

(async () => {
  for (const moduleName of modules) {
    for (const action of actions) {
      const existing = await Permission.findOne({
        where: {
          module: moduleName,
          action: `${action}_${moduleName}`,
        }
      });

      if (!existing) {
        await Permission.create({
          module: moduleName,
          action: `${action}_${moduleName}`,
          description: `${action} ${moduleName}`,
        });
        console.log(`✅ Created permission: ${action}_${moduleName}`);
      } else {
        console.log(`✔️ Already exists: ${action}_${moduleName}`);
      }
    }
  }

  process.exit();
})();
