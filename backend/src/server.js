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

const app = express();

app.use(cors({ origin: env.CLIENT_URL }));
app.use(express.json());

connectDB();

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

app.use(errorHandler);

const server = app.listen(env.PORT, () => {
  console.log('Pulse Continuous Care API running on port ' + env.PORT);
});

module.exports = app;
