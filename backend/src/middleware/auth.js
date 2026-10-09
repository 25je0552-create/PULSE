const jwt = require('jsonwebtoken');
const env = require('../config/env');
const store = require('../models/store');

const authMiddleware = (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    req.user = store.users[0];
    return next();
  }

  const token = authHeader.split(' ')[1];
  try {
    const decoded = jwt.verify(token, env.JWT_SECRET);
    const user = store.users.find(u => u.id === decoded.id);
    req.user = user || store.users[0];
    next();
  } catch (err) {
    req.user = store.users[0];
    next();
  }
};

module.exports = authMiddleware;
