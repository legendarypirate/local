const cloudinary = require('../config/cloudinary');

/**
 * Upload a multer memory file buffer to Cloudinary.
 * @returns {Promise<string>} secure_url
 */
function uploadDeliveryImage(file) {
  return new Promise((resolve, reject) => {
    const stream = cloudinary.uploader.upload_stream(
      { resource_type: 'image' },
      (error, result) => {
        if (error) return reject(error);
        if (!result?.secure_url) return reject(new Error('Cloudinary upload returned no URL'));
        resolve(result.secure_url);
      }
    );
    stream.end(file.buffer);
  });
}

module.exports = { uploadDeliveryImage };
