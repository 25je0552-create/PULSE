const store = require('../models/store');
const { generateAiChatResponse, generateInsightFromSignals, generatePreConsultDigest } = require('../services/geminiService');
const { getSignalsSummary } = require('../services/signalService');

const chat = async (req, res) => {
  const { message } = req.body;
  const recentCheckin = store.checkins[store.checkins.length - 1];
  
  const context = {
    patient: {
      condition: store.patientProfile.beachheadCondition,
      age: store.patientProfile.age
    },
    recentCheckin
  };

  const response = await generateAiChatResponse({ message, context });

  if (!response.safetyEscalated) {
    store.aiChatHistory.push({
      id: 'msg_' + Date.now(),
      sender: 'user',
      text: message,
      timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    });
    store.aiChatHistory.push({
      id: 'msg_' + (Date.now() + 1),
      sender: 'pulse_ai',
      text: response.text,
      timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    });
  }

  return res.json({
    success: true,
    ...response
  });
};

const getChatHistory = (req, res) => {
  return res.json({
    success: true,
    messages: store.aiChatHistory
  });
};

const getInsight = async (req, res) => {
  const signals = getSignalsSummary(7);
  const insight = await generateInsightFromSignals(signals);
  return res.json({
    success: true,
    insight,
    signalsSummary: signals
  });
};

const getSummary = async (req, res) => {
  const digest = await generatePreConsultDigest(store.patientProfile);
  return res.json({
    success: true,
    digest
  });
};

module.exports = {
  chat,
  getChatHistory,
  getInsight,
  getSummary
};
