const store = require('../models/store');

const getGoals = (req, res) => {
  return res.json({
    success: true,
    goals: store.goals
  });
};

const updateActiveGoal = (req, res) => {
  const { title, durationMinutes, frequency, preferredTime, difficulty, category } = req.body;
  
  store.goals.forEach(g => { g.isActive = false; });

  const existing = store.goals.find(g => g.title === title);
  if (existing) {
    if (durationMinutes) existing.durationMinutes = durationMinutes;
    if (frequency) existing.frequency = frequency;
    if (preferredTime) existing.preferredTime = preferredTime;
    if (difficulty) existing.difficulty = difficulty;
    existing.isActive = true;
    return res.json({ success: true, goal: existing });
  }

  const newGoal = {
    id: 'goal_' + Date.now(),
    title: title || 'Protect 10 minutes for yourself',
    description: 'A gentle pause to balance daily stress.',
    category: category || 'Pacing',
    durationMinutes: durationMinutes || 10,
    frequency: frequency || 'Every day',
    preferredTime: preferredTime || 'Afternoon',
    difficulty: difficulty || 'Easy',
    targetDays: 7,
    completedDays: 1,
    isActive: true,
    source: 'Adaptive Selection'
  };

  store.goals.unshift(newGoal);
  return res.status(201).json({ success: true, goal: newGoal });
};

const adaptGoalSize = (req, res) => {
  const { goalId, newDuration, newAction } = req.body;
  const goal = store.goals.find(g => g.id === goalId) || store.goals[0];
  
  if (newDuration) {
    goal.durationMinutes = newDuration;
    goal.title = goal.title.replace(/\d+\s*min(utes)?/i, newDuration + ' minutes');
  }
  if (newAction) {
    goal.title = newAction;
  }
  goal.difficulty = 'Easy';

  return res.json({
    success: true,
    message: 'Goal adapted successfully.',
    goal
  });
};

module.exports = {
  getGoals,
  updateActiveGoal,
  adaptGoalSize
};
