const express = require('express');
const cors = require('cors');
const env = require('./config/env');
const { connectDB, getDbStatus } = require('./config/db');
const errorHandler = require('./middleware/error');

const authRoutes = require('./routes/authRoutes');
const patientRoutes = require('./routes/patientRoutes');
const checkinRoutes = require('./routes/checkinRoutes');
const aiRoutes = require('./routes/aiRoutes');
const goalRoutes = require('./routes/goalRoutes');
const careRoutes = require('./routes/careRoutes');
const awarenessRoutes = require('./routes/awarenessRoutes');
const recordsRoutes = require('./routes/recordsRoutes');
const familyRoutes = require('./routes/familyRoutes');
const wellbeingRoutes = require('./routes/wellbeingRoutes');
const safetyRoutes = require('./routes/safetyRoutes');
const doctalkRoutes = require('./routes/doctalkRoutes');

const app = express();

app.use(cors({ origin: env.CLIENT_URL }));
app.use(express.json());

connectDB();

app.get('/', (req, res) => {
  res.json({
    status: 'active',
    product: 'Pulse Continuous Care Platform API',
    version: '1.0.0',
    endpoints: {
      health: '/api/health',
      auth: '/api/auth',
      patient: '/api/patient',
      checkins: '/api/checkins',
      ai: '/api/ai',
      goals: '/api/goals',
      care: '/api/care',
      awareness: '/api/awareness',
      records: '/api/records',
      family: '/api/family',
      wellbeing: '/api/wellbeing',
      safety: '/api/safety',
      doctalk: '/api/doctalk'
    }
  });
});

app.get('/api/health', (req, res) => {
  res.json({
    status: 'healthy',
    product: 'Pulse Continuous Care Platform',
    version: '1.0.0',
    dbConnected: getDbStatus()
  });
});

app.use('/api/auth', authRoutes);
app.use('/api/patient', patientRoutes);
app.use('/api/checkins', checkinRoutes);
app.use('/api/ai', aiRoutes);
app.use('/api/goals', goalRoutes);
app.use('/api/care', careRoutes);
app.use('/api/awareness', awarenessRoutes);
app.use('/api/records', recordsRoutes);
app.use('/api/family', familyRoutes);
app.use('/api/wellbeing', wellbeingRoutes);
app.use('/api/safety', safetyRoutes);
app.use('/api/doctalk', doctalkRoutes);

app.use(errorHandler);

const server = app.listen(env.PORT, '0.0.0.0', () => {
  console.log('Pulse Continuous Care API running on port ' + env.PORT);
});

module.exports = app;
