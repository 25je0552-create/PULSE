const store = require('../models/store');
const { getSignalsSummary } = require('../services/signalService');

const getWellbeingHub = (req, res) => {
  const summary = getSignalsSummary(7);
  const activeGoal = store.goals.find(g => g.isActive) || store.goals[0];
  const lastReflection = store.wellbeingReflections[store.wellbeingReflections.length - 1];

  return res.json({
    success: true,
    recentWellbeing: {
      mood: 'Okay',
      moodSubtitle: 'Gentle baseline',
      stress: 'Moderate',
      stressSubtitle: 'Evening indicator',
      energy: 'Low',
      energySubtitle: 'Resting phase',
      sleep: 'Needs attention',
      sleepSubtitle: 'Interrupted rhythm'
    },
    latestReflection: lastReflection || {
      text: 'I\'ve been feeling overwhelmed with work lately.',
      date: '2026-09-24',
      isPrivate: true
    },
    noticedPattern: {
      title: 'What you\'ve been noticing',
      description: 'Your recent check-ins show higher stress on days when your sleep was lower. Patterns can take time to become clear. Observing connections helps you explore rhythms without self-judgment.'
    },
    smallStep: {
      title: 'Take 10 quiet minutes away from your screen today.',
      description: 'Choose something that feels realistic, not perfect. No streak pressure.'
    }
  });
};

const saveReflection = (req, res) => {
  const { text } = req.body;
  const newRef = {
    id: 'ref_' + Date.now(),
    text: text || '',
    date: new Date().toISOString().split('T')[0],
    savedLocally: true,
    isPrivate: true
  };

  store.wellbeingReflections.push(newRef);
  return res.status(201).json({
    success: true,
    message: 'Reflection saved locally and securely.',
    reflection: newRef
  });
};

module.exports = {
  getWellbeingHub,
  saveReflection
};
