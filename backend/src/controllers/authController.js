const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const env = require('../config/env');
const store = require('../models/store');

const login = (req, res) => {
  const { identifier, email, password, role } = req.body;
  const loginEmail = (identifier || email || '').trim().toLowerCase();
  const targetRole = role || 'patient';

  if (!loginEmail || !password) {
    return res.status(400).json({
      success: false,
      message: 'Email and password are required'
    });
  }

  const user = store.users.find(u => 
    (u.email.toLowerCase() === loginEmail || u.phone === loginEmail) &&
    (!role || u.role === targetRole)
  );

  if (!user) {
    return res.status(401).json({
      success: false,
      message: 'Invalid credentials. User not found.'
    });
  }

  const isPasswordValid = bcrypt.compareSync(password, user.passwordHash);
  if (!isPasswordValid) {
    return res.status(401).json({
      success: false,
      message: 'Invalid credentials. Incorrect password.'
    });
  }

  const token = jwt.sign(
    { id: user.id, email: user.email, role: user.role, name: user.name },
    env.JWT_SECRET,
    { expiresIn: '7d' }
  );

  return res.json({
    success: true,
    token,
    user: {
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      role: user.role
    }
  });
};

const register = (req, res) => {
  const { name, email, password, phone, role } = req.body;

  if (!name || !email || !password) {
    return res.status(400).json({
      success: false,
      message: 'Name, email, and password are required'
    });
  }

  const normalizedEmail = email.trim().toLowerCase();
  const existingUser = store.users.find(u => u.email.toLowerCase() === normalizedEmail);
  if (existingUser) {
    return res.status(400).json({
      success: false,
      message: 'An account with this email already exists'
    });
  }

  const salt = bcrypt.genSaltSync(10);
  const passwordHash = bcrypt.hashSync(password, salt);
  const newUser = {
    id: 'usr_' + Date.now(),
    name: name.trim(),
    email: normalizedEmail,
    phone: phone ? phone.trim() : '+91 98765 00000',
    passwordHash,
    role: role || 'patient',
    createdAt: new Date().toISOString()
  };

  store.users.push(newUser);

  const token = jwt.sign(
    { id: newUser.id, email: newUser.email, role: newUser.role, name: newUser.name },
    env.JWT_SECRET,
    { expiresIn: '7d' }
  );

  return res.status(201).json({
    success: true,
    token,
    user: {
      id: newUser.id,
      name: newUser.name,
      email: newUser.email,
      phone: newUser.phone,
      role: newUser.role
    }
  });
};

const getMe = (req, res) => {
  return res.json({
    success: true,
    user: req.user
  });
};

module.exports = {
  login,
  register,
  getMe
};
