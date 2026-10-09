const mongoose = require('mongoose');
const env = require('./env');

let isConnected = false;

const connectDB = async () => {
  if (!env.MONGODB_URI) {
    return false;
  }
  try {
    const conn = await mongoose.connect(env.MONGODB_URI);
    isConnected = true;
    return true;
  } catch (error) {
    isConnected = false;
    return false;
  }
};

const getDbStatus = () => {
  return isConnected;
};

module.exports = {
  connectDB,
  getDbStatus
};
