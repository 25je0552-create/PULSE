const store = require('../models/store');

const getCareOverview = (req, res) => {
  return res.json({
    success: true,
    careTeam: store.careTeam,
    upcomingAppointment: store.appointments[0],
    preConsultDigestReady: true
  });
};

const getCareProfessional = (req, res) => {
  return res.json({
    success: true,
    partner: store.careTeam.partner,
    recentContext: {
      checkinsLogged: 6,
      activeGoals: 2,
      newPatterns: 1,
      lastReviewDate: '12 Sep 2026'
    }
  });
};

const connectCareProfessional = (req, res) => {
  const { inviteCode } = req.body;
  store.careTeam.connected = true;
  store.careTeam.partner.partnerCode = inviteCode || 'SJH-4829';
  return res.json({
    success: true,
    message: 'Connected to care professional.',
    partner: store.careTeam.partner
  });
};

const getAppointments = (req, res) => {
  return res.json({
    success: true,
    appointments: store.appointments
  });
};

const addAppointmentQuestion = (req, res) => {
  const { question } = req.body;
  if (question && store.appointments[0]) {
    store.appointments[0].questions.push(question);
  }
  return res.json({
    success: true,
    questions: store.appointments[0]?.questions || []
  });
};

const getPreConsultSummary = (req, res) => {
  return res.json({
    success: true,
    summary: store.preConsultSummary
  });
};

const approvePreConsultSummary = (req, res) => {
  store.preConsultSummary.isApprovedByPatient = true;
  store.preConsultSummary.isDraft = false;
  return res.json({
    success: true,
    message: 'Summary approved. Context will be available for Dr. Sharma during consultation.',
    summary: store.preConsultSummary
  });
};

module.exports = {
  getCareOverview,
  getCareProfessional,
  connectCareProfessional,
  getAppointments,
  addAppointmentQuestion,
  getPreConsultSummary,
  approvePreConsultSummary
};
