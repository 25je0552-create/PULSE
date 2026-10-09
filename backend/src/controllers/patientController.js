const store = require('../models/store');
const { getSignalsSummary } = require('../services/signalService');

const getProfile = (req, res) => {
  return res.json({
    success: true,
    profile: store.patientProfile
  });
};

const updateProfile = (req, res) => {
  const updates = req.body;
  Object.assign(store.patientProfile, updates);
  return res.json({
    success: true,
    profile: store.patientProfile
  });
};

const saveBaseline = (req, res) => {
  const { conditions, supportGoals, receivingProfessionalCare, providers, supportPreferences } = req.body;
  if (conditions) store.patientProfile.conditions = conditions;
  if (supportGoals) store.patientProfile.supportGoals = supportGoals;
  if (receivingProfessionalCare !== undefined) {
    store.patientProfile.receivingProfessionalCare = receivingProfessionalCare;
  }
  if (providers) store.patientProfile.providers = providers;
  if (supportPreferences) store.patientProfile.supportPreferences = supportPreferences;
  store.patientProfile.onboardingCompleted = true;

  return res.json({
    success: true,
    message: 'Baseline preferences saved.',
    profile: store.patientProfile
  });
};

const getHome = (req, res) => {
  const signals = getSignalsSummary(7);
  const activeGoal = store.goals.find(g => g.isActive) || store.goals[0];
  const featuredArticle = store.awarenessLibrary.find(a => a.isFeatured) || store.awarenessLibrary[0];

  return res.json({
    success: true,
    greeting: 'Good morning, ' + (store.patientProfile.fullName.split(' ')[0] || 'Ananya'),
    subgreeting: 'How are you feeling today?',
    pulseToday: {
      mood: 'Okay',
      moodDetail: 'Logged 8:30 AM',
      stress: 'Moderate',
      stressDetail: 'Steady',
      energy: 'Low',
      energyDetail: 'Needs rest'
    },
    nextSmallStep: {
      title: activeGoal.title,
      description: activeGoal.description,
      duration: activeGoal.durationMinutes + ' min',
      category: activeGoal.category
    },
    progressSummary: {
      checkinsThisWeek: 4,
      totalTarget: 7,
      message: 'Keep building your pattern.',
      weekDays: [
        { day: 'Mon', completed: true },
        { day: 'Tue', completed: true },
        { day: 'Wed', completed: true },
        { day: 'Thu', completed: true },
        { day: 'Fri', completed: false },
        { day: 'Sat', completed: false },
        { day: 'Sun', completed: false }
      ]
    },
    careTeamStatus: {
      connected: store.careTeam.connected,
      doctorName: store.careTeam.partner.name,
      nextAppointment: '24 Sep 2026'
    },
    recommendedAwareness: {
      id: featuredArticle.id,
      title: featuredArticle.title,
      category: featuredArticle.category,
      duration: featuredArticle.duration,
      subtitle: featuredArticle.subtitle
    }
  });
};

module.exports = {
  getProfile,
  updateProfile,
  saveBaseline,
  getHome
};
