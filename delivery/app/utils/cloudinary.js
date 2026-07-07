const cloudinary = require('../config/cloudinary');

/**
 * Upload a multer memory file buffer to Cloudinary.
 * @returns {Promise<string>} secure_url
 */
function uploadImage(file, folder = 'delivery') {
  const uploadPromise = new Promise((resolve, reject) => {
    const stream = cloudinary.uploader.upload_stream(
      { resource_type: 'image', folder },
      (error, result) => {
        if (error) return reject(error);
        if (!result?.secure_url) return reject(new Error('Cloudinary upload returned no URL'));
        resolve(result.secure_url);
      }
    );
    stream.end(file.buffer);
  });

  const timeoutPromise = new Promise((_, reject) => {
    setTimeout(() => reject(new Error('Image upload timed out')), 45000);
  });

  return Promise.race([uploadPromise, timeoutPromise]);
}

function uploadDeliveryImage(file) {
  return uploadImage(file, 'delivery');
}

function uploadGoodImage(file) {
  return uploadImage(file, 'goods');
}

module.exports = { uploadDeliveryImage, uploadGoodImage, uploadImage };
