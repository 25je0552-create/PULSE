const store = require('../models/store');
const { getSignalsSummary } = require('../services/signalService');

const createCheckin = (req, res) => {
  const { mood, stress, energy, sleep, sleepHours, reflection, symptoms, goalCompleted } = req.body;
  const newCheckin = {
    id: 'chk_' + Date.now(),
    date: new Date().toISOString().split('T')[0],
    timestamp: new Date().toISOString(),
    mood: mood || 'Okay',
    stress: stress || 'Moderate',
    energy: energy || 'Okay',
    sleep: sleep || 'Fair',
    sleepHours: Number(sleepHours) || 6.5,
    reflection: reflection || '',
    symptoms: symptoms || [],
    goalCompleted: goalCompleted !== undefined ? goalCompleted : true
  };

  store.checkins.push(newCheckin);

  return res.status(201).json({
    success: true,
    message: 'Check-in saved successfully.',
    checkin: newCheckin
  });
};

const getHistory = (req, res) => {
  const limit = parseInt(req.query.limit, 10) || 30;
  const history = store.checkins.slice(-limit).reverse();
  return res.json({
    success: true,
    checkins: history
  });
};

const getProgress = (req, res) => {
  const range = parseInt(req.query.range, 10) || 7;
  const summary = getSignalsSummary(range);
  const activeGoal = store.goals.find(g => g.isActive) || store.goals[0];

  return res.json({
    success: true,
    range,
    summary,
    activeGoal: {
      id: activeGoal.id,
      title: activeGoal.title,
      description: activeGoal.description,
      category: activeGoal.category,
      completedDays: activeGoal.completedDays,
      targetDays: activeGoal.targetDays
    }
  });
};

module.exports = {
  createCheckin,
  getHistory,
  getProgress
};
