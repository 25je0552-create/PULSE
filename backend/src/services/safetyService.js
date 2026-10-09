const riskPatterns = [
  /\b(suicid|kill\s*myself|end\s*my\s*life|want\s*to\s*die|self[-\s]?harm|cut\s*myself|hurt\s*myself)\b/i,
  /\b(overdose|take\s*all\s*my\s*pills|can'?t\s*go\s*on\s*living|no\s*reason\s*to\s*live)\b/i,
  /\b(hanging\s*myself|jump\s*off|bleed\s*out)\b/i
];

const checkSafetyRisk = (text) => {
  if (!text || typeof text !== 'string') {
    return { isRisk: false };
  }

  const match = riskPatterns.some(pattern => pattern.test(text));
  if (match) {
    return {
      isRisk: true,
      reason: 'Self-harm or acute mental health crisis signal detected.',
      actionRequired: 'ROUTE_TO_SAFETY_HELP',
      escalationMessage: 'We are deeply concerned about your safety. Based on what you shared, normal AI coaching has paused. Please connect with immediate human support or a trusted professional right away.',
      resources: [
        {
          type: 'KIRAN National Mental Health Helpline (India)',
          contact: '1800-599-0019',
          hours: '24/7'
        },
        {
          type: 'Tele-MANAS (Govt. of India)',
          contact: '14416',
          hours: '24/7'
        },
        {
          type: 'National Emergency Number',
          contact: '112',
          hours: '24/7'
        }
      ]
    };
  }

  return { isRisk: false };
};

module.exports = {
  checkSafetyRisk
};
