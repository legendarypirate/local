const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs"); // Using bcryptjs for hashing and comparing passwords
const db = require("../models");
const User = db.users;  // Assuming your users table is named 'users'
const secretKey = 'your_secret_key';  // You can store this key in .env for better security
const axios = require("axios");
const getPermissionsForRole = db.role_permissions;  // Assuming your users table is named 'users'

// Register a new user
exports.register = async (req, res) => {
  const { username, password, role } = req.body;

  if (!username || !password) {
    return res.status(400).json({ message: "Username and password are required!" });
  }

  try {
    // Check if user already exists
    const existingUser = await User.findOne({ where: { username } });
    if (existingUser) {
      return res.status(400).json({ message: "User already exists!" });
    }

    // Hash the password using bcryptjs
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create a new user in the database
    const newUser = await User.create({
      username,
      password: hashedPassword,
      role: role || "user",  // Default role is 'user'
    });

    // Generate JWT token
    const token = jwt.sign({ id: newUser.id, username: newUser.username, role: newUser.role }, secretKey, { expiresIn: "30m" });

    res.status(201).json({
      success: true,
      message: "User registered successfully!",
      token,
      user: {
        id: newUser.id,
        username: newUser.username,
        role: newUser.role
      }
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  }
};

// Login user without role restriction
exports.login = async (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ message: "Username and password are required!" });
  }

  try {
    const user = await User.findOne({ where: { username } });
    if (!user) {
      return res.status(401).json({ message: "Invalid credentials!" });
    }

    const passwordMatch = await bcrypt.compare(password, user.password);
    if (!passwordMatch) {
      return res.status(401).json({ message: "Invalid credentials!" });
    }

    // Fetch permissions via role_permissions join table, include permission details
    const rolePermissions = await db.role_permissions.findAll({
      where: { role_id: user.role_id },
      include: [{
        model: db.permissions,
        as: 'permission',      // must match belongsTo alias in your model setup
        attributes: ['module', 'action'], // fetch actual columns you have
      }],
    });

    // Map to simple array of strings "module:action"
    const permissions = rolePermissions
      .map(rp => rp.permission ? `${rp.permission.module}:${rp.permission.action}` : null)
      .filter(Boolean);

    // Create JWT payload with permissions included
    const tokenPayload = {
      id: user.id,
      username: user.username,
      role: user.role_id,
      permissions,
    };

    const token = jwt.sign(tokenPayload, secretKey, { expiresIn: "30m" });

    res.json({
      success: true,
      token,
      user: {
        id: user.id,
        username: user.username,
        role: user.role_id,
        permissions,
      },
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  }
};


exports.mobile_login = async (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ message: "username and password are required!" });
  }

  try {
    const user = await User.findOne({ where: { username } });

    if (!user ) {
      return res.status(401).json({ message: "Invalid credentials!" });
    }

    const passwordMatch = await bcrypt.compare(password, user.password);

    if (!passwordMatch) {
      return res.status(401).json({ message: "Invalid credentials!" });
    }

    const token = jwt.sign({ id: user.id, phone: user.phone, role: user.role }, secretKey, { expiresIn: "30m" });

    res.json({
      success: true,
      token,
      user: {
        id: user.id,
        username: user.username,
        role: user.role_id,
      }
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  }
};
// Verify the JWT token
exports.verifyToken = (req, res, next) => {
  const token = req.headers["authorization"];

  if (!token) {
    return res.status(401).json({ message: "Token is missing!" });
  }

  jwt.verify(token, secretKey, (err, decoded) => {
    if (err) {
      return res.status(401).json({ message: "Token is invalid!" });
    }
    req.user = decoded;
    next();
  });
};


exports.mobile_register = async (req, res) => {
  const { lastname, firstname,company,position, email, phone } = req.body;
  console.log(req.body);

  if (!lastname || !firstname || !company) {
    return res.status(400).json({ message: "lastname, firstname, and company are required!" });
  }

  try {
    // Check if user already exists
    const existingUser = await User.findOne({ where: { lastname } });
    if (existingUser) {
      return res.status(400).json({ message: "User already exists!" });
    }

    // Generate a 4-digit OTP
    const randomOTP = Math.floor(1000 + Math.random() * 9000);

    // Create user with OTP
    const newUser = await User.create({
      lastname,
      firstname,
      company,
      position,
      email,
      phone,
      otp: randomOTP
    });

    console.log("Inserted user:", newUser.toJSON());

    // Generate JWT token
    const token = jwt.sign(
      { id: newUser.id, username: newUser.username, phone: newUser.phone },
      secretKey,
      { expiresIn: "30m" }
    );

    // Send OTP via SMS
    const smsUrl = `https://api.messagepro.mn/send?from=72278880&to=${phone}&text=Tanii neg udaagiin nuuts code ${randomOTP}`;
    
    const headers = {
      "x-api-key": "d1856eb0c137cb4dc7e43dc2efdfd43a", // Your API key
      "Content-Type": "application/json",
    };

    try {
      const smsResponse = await axios.get(smsUrl, { headers });
      console.log("SMS API Response:", smsResponse.data);
    } catch (smsError) {
      console.error(
        "Error sending SMS:",
        smsError.response ? smsError.response.data : smsError.message
      );
    }

    // Respond to the client
    res.status(201).json({
      success: true,
      message: "User registered successfully! OTP sent via SMS.",
      token,
      user: {
        id: newUser.id,
        lastname: newUser.lastname,
        firstname: newUser.firstname,
        email: newUser.email,
        phone: newUser.phone,
        company: newUser.company,
        position: newUser.position
      }
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  }
};

exports.verifyOtp = async (req, res) => {
  const { id, otp } = req.body;

  if (!id || !otp) {
    return res.status(400).json({ message: "User ID and OTP are required!" });
  }

  try {
    // Find user by ID
    const user = await User.findOne({ where: { id: id } });

    if (!user) {
      return res.status(404).json({ message: "User not found!" });
    }

    // Check if OTP matches
    if (user.otp !== otp) {
      return res.status(400).json({ message: "Invalid OTP!" });
    }

    // Update user as verified
    await User.update({ otp: null, phone_verified: true }, { where: { id: id } });

    res.json({ success: true, message: "Phone verified successfully!" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  }
};

exports.updateInfo = async (req, res) => {
  try {
    const { id, password } = req.body;

    // Validate required fields
    if (!id ) {
      return res.status(400).json({ message: "User ID  are required!" });
    }

    // Find user by ID
    const user = await User.findOne({ where: { id: id } });

    if (!user) {
      return res.status(404).json({ message: "User not found!" });
    }

    // Prepare data for update
    const updatedData = { };

    // If a new password is provided, hash it before saving
    if (password) {
      const saltRounds = 10;
      const hashedPassword = await bcrypt.hash(password, saltRounds);
      updatedData.password = hashedPassword;
    }

    // Update user information
    await User.update(updatedData, { where: { id: id } });

    res.json({ success: true, message: "User info updated successfully!" });
  } catch (err) {
    console.error("Error updating user info:", err);
    res.status(500).json({ message: "Internal server error" });
  }
};
