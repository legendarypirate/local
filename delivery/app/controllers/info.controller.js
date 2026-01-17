const db = require("../models");
const Info = db.infos;
const Op = db.Sequelize.Op;
const multer = require("multer");
const path = require("path");
const fs = require("fs");

// Ensure directories exist
const ensureDir = (dir) => {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
};

ensureDir("app/assets");
ensureDir("app/assets/audios");

// Storage settings for image and audio files
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    if (file.mimetype.startsWith("image/")) {
      cb(null, "app/assets"); // Image storage
    } else if (file.mimetype === "audio/mpeg") {
      cb(null, "app/assets/audios"); // MP3 storage
    } else {
      return cb(new Error("Invalid file type!"));
    }
  },
  filename: function (req, file, cb) {
    cb(null, file.fieldname + "-" + Date.now() + path.extname(file.originalname));
  },
});

// Initialize multer
const upload = multer({
  storage: storage,
  limits: { fileSize: 10 * 1024 * 1024 }, // 10MB max file size
  fileFilter: function (req, file, cb) {
    console.log("Uploading file:", file.originalname, "Type:", file.mimetype);

    if (file.mimetype.startsWith("image/") || file.mimetype === "audio/mpeg") {
      cb(null, true);
    } else {
      console.error("Invalid file type:", file.mimetype);
      cb(new Error("Only image and MP3 files are allowed!"), false);
    }
  }
}).fields([
  { name: "image", maxCount: 1 },
  { name: "audio", maxCount: 1 },
]);

// Create and Save a new Info entry
exports.create = (req, res) => {
  upload(req, res, function (err) {
    if (err instanceof multer.MulterError) {
      return res.status(500).json({ success: false, message: "Error uploading file." });
    } else if (err) {
      return res.status(500).json({ success: false, message: err.message || "Unknown error." });
    }

    // Validate request
    if (!req.body.title || !req.files.image) {
      return res.status(400).json({ success: false, message: "Title and image are required!" });
    }

    // Create an Info entry
    const info = {
      title: req.body.title,
      doctor: req.body.doctor,
      gender: req.body.gender,
      category: req.body.category,
      age: req.body.age,
      richtext: req.body.richtext,
      image: req.files.image ? req.files.image[0].filename : null, // Store image filename
      audio: req.files.audio ? req.files.audio[0].filename : null, // Store audio filename
    };

    // Save Info in the database
    Info.create(info)
      .then((data) => res.json({ success: true, data: data }))
      .catch((err) => res.status(500).json({ success: false, message: err.message || "Some error occurred while creating the entry." }));
  });
};

// Retrieve all Infos from the database

exports.findAll = async (req, res) => {
  const title = req.query.title;
  let condition = { isactive: 1 }; // Default condition

  if (title) {
    condition.title = { [Op.like]: `%${title}%` }; // Add title condition if provided
  }

  try {
    const data = await Info.findAll({ where: condition });
    res.json({ success: true, data: data });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message || "Some error occurred while retrieving data." });
  }
};

// Find a single Info entry by ID
exports.findOne = (req, res) => {
  const id = req.params.id;

  Info.findByPk(id)
    .then((data) => {
      if (data) {
        res.json({ success: true, data: data });
      } else {
        res.status(404).json({ success: false, message: `Cannot find entry with id=${id}.` });
      }
    })
    .catch((err) => {
      res.status(500).json({ success: false, message: "Error retrieving entry with id=" + id });
    });
};

// Update an Info entry by ID
exports.update = (req, res) => {
  const id = req.params.id;

  // Use multer to process the form data (including files)
  upload(req, res, function (err) {
    if (err instanceof multer.MulterError) {
      return res.status(500).json({ success: false, message: "Error uploading file." });
    } else if (err) {
      return res.status(500).json({ success: false, message: err.message || "Unknown error." });
    }

    // Validate request (ensure at least title or image is present)
    if (Object.keys(req.body).length === 0 && !req.files.image && !req.body.title) {
      return res.status(400).json({
        success: false,
        message: "Request body cannot be empty and image/title is required.",
      });
    }

    // Fetch the current entry from the database to retain previous image/audio if not provided
    Info.findByPk(id)
      .then((existingEntry) => {
        if (!existingEntry) {
          return res.status(404).json({
            success: false,
            message: "Entry not found.",
          });
        }

        // Prepare the data for updating the entry
        const updateData = {
          title: req.body.title || existingEntry.title,
          doctor: req.body.doctor || existingEntry.doctor,
          gender: req.body.gender || existingEntry.gender,
          category: req.body.category || existingEntry.category,
          age: req.body.age || existingEntry.age,
          isactive: req.body.isactive || existingEntry.isactive,
          richtext: req.body.richtext || existingEntry.richtext,
          image: req.files.image ? req.files.image[0].filename : existingEntry.image, // Keep previous image if not provided
          audio: req.files.audio ? req.files.audio[0].filename : existingEntry.audio, // Keep previous audio if not provided
        };

        // Update the entry in the database
        return Info.update(updateData, { where: { id: id } });
      })
      .then((num) => {
        if (num == 1) {
          // Successfully updated
          return Info.findByPk(id); // Fetch the updated entry
        } else {
          throw new Error("No changes were made or entry not found.");
        }
      })
      .then((updatedEntry) => {
        res.json({
          success: true,
          message: "Entry was updated successfully.",
          data: updatedEntry,
        });
      })
      .catch((err) => {
        res.status(500).json({
          success: false,
          message: "Error updating entry with id=" + id,
          error: err.message,
        });
      });
  });
};

// Delete an Info entry by ID
exports.delete = (req, res) => {
  const id = req.params.id;

  Info.destroy({ where: { id: id } })
    .then((num) => {
      if (num == 1) {
        res.json({ success: true, message: "Entry was deleted successfully!" });
      } else {
        res.status(404).json({ success: false, message: `Cannot delete entry with id=${id}. Maybe it was not found!` });
      }
    })
    .catch((err) => {
      res.status(500).json({ success: false, message: "Could not delete entry with id=" + id });
    });
};

// Delete all Info entries from the database
exports.deleteAll = (req, res) => {
  Info.destroy({ where: {}, truncate: false })
    .then((nums) => {
      res.json({ success: true, message: `${nums} entries were deleted successfully!` });
    })
    .catch((err) => {
      res.status(500).json({ success: false, message: err.message || "Some error occurred while removing all entries." });
    });
};

// Find all published entries
exports.findAllPublished = (req, res) => {
  Info.findAll({ where: { published: true } })
    .then((data) => {
      res.json({ success: true, data: data });
    })
    .catch((err) => {
      res.status(500).json({ success: false, message: err.message || "Some error occurred while retrieving data." });
    });
};
