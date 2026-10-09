const dotenv = require('dotenv');
dotenv.config();

module.exports = {
  PORT: process.env.PORT || 5000,
  MONGODB_URI: process.env.MONGODB_URI || '',
  JWT_SECRET: process.env.JWT_SECRET || 'pulse_secret_jwt_key_2026',
  GEMINI_API_KEY: process.env.GEMINI_API_KEY || '',
  CLIENT_URL: process.env.CLIENT_URL || '*'
};
