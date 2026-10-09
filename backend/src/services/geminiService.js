const env = require('../config/env');
const { checkSafetyRisk } = require('./safetyService');

const SYSTEM_INSTRUCTION = `You are Pulse AI, a health-support assistant inside a doctor-connected continuous-care application.
Your role:
- explain patterns from supplied user-reported data;
- encourage safe, small non-medical behavior changes;
- help the patient understand their own daily rhythms;
- support preparation for conversations with qualified doctors and therapists.
Never diagnose, prescribe, change medication, or claim certainty.
Do not invent patient data.
Always distinguish:
1) observed self-reported data,
2) possible non-diagnostic interpretation,
3) safe small next step,
4) when a human professional should be involved.
Keep responses supportive, calm, concise, and non-judgmental.`;

const generateAiChatResponse = async ({ message, context }) => {
  const safetyCheck = checkSafetyRisk(message);
  if (safetyCheck.isRisk) {
    return {
      safetyEscalated: true,
      text: safetyCheck.escalationMessage,
      resources: safetyCheck.resources,
      suggestedAction: 'ROUTE_TO_SAFETY'
    };
  }

  if (env.GEMINI_API_KEY) {
    try {
      const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${env.GEMINI_API_KEY}`;
      const prompt = `System prompt: ${SYSTEM_INSTRUCTION}
Patient context: ${JSON.stringify(context || {})}
User message: ${message}`;

      const res = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          contents: [{ parts: [{ text: prompt }] }]
        })
      });

      if (res.ok) {
        const data = await res.json();
        const candidate = data.candidates?.[0]?.content?.parts?.[0]?.text;
        if (candidate) {
          const outputSafety = checkSafetyRisk(candidate);
          if (outputSafety.isRisk) {
            return {
              safetyEscalated: true,
              text: outputSafety.escalationMessage,
              resources: outputSafety.resources
            };
          }
          return {
            safetyEscalated: false,
            text: candidate,
            suggestedAction: 'CONTINUE'
          };
        }
      }
    } catch (e) {
    }
  }

  const lower = (message || '').toLowerCase();
  let responseText = 'Taking brief moments to step back can give your nervous system a pause. Would you like a 2-minute breathing reset or ideas on setting gentle boundaries today?';

  if (lower.includes('stress') || lower.includes('overwhelm') || lower.includes('pressure')) {
    responseText = 'I noticed work feels overwhelming right now. When stress rises, taking a structured 10-minute pause away from screens can give your autonomic system a moment to recover.';
  } else if (lower.includes('sleep') || lower.includes('tired') || lower.includes('energy')) {
    responseText = 'Low sleep and lower energy often travel together. Rather than forcing productivity today, consider protecting 10 quiet minutes this afternoon for rest.';
  } else if (lower.includes('appointment') || lower.includes('doctor') || lower.includes('consult')) {
    responseText = 'Preparing your talking points beforehand helps make clinical visits much more useful. We can summarize your recent sleep and stress trends in a 1-page digest for Dr. Sharma.';
  }

  return {
    safetyEscalated: false,
    text: responseText,
    suggestedAction: 'CONTINUE'
  };
};

const generateInsightFromSignals = async (signals) => {
  return {
    title: 'Your wellbeing pattern',
    subtitle: 'Here’s what your recent self-reported check-ins may be gently highlighting.',
    patternObservation: 'Your stress has been higher on days when your sleep and energy were lower.',
    explanation: 'When multiple routines shift together, observing the broader rhythm can help illuminate small points of balance rather than judging one difficult day. Sleep and energy often act as anchors for how we perceive daily stress.',
    smallStep: {
      title: 'Protect 10 minutes of uninterrupted time for yourself today.',
      description: 'Choose something realistic rather than trying to change everything at once. Step away from work screens or pause between tasks.',
      duration: '10 min',
      difficulty: 'Easy'
    }
  };
};

const generatePreConsultDigest = async (patientData) => {
  return {
    reviewWindow: '30d (12 Sep - 24 Sep 2026)',
    checkinsCount: 6,
    activeGoalsCount: 2,
    patternsCount: 1,
    observations: [
      {
        title: 'Stress & sleep cadence',
        description: 'You reported higher stress on days when sleep duration was lower. Reflects self-logged entries between 12 Sep and 22 Sep. Highlights personal rhythm without asserting clinical cause.'
      },
      {
        title: 'Screen rest habit',
        description: 'Your energy was reported higher on days you took your 10-minute work screen pause. Correlates with your afternoon recharge moments.'
      }
    ],
    signalsSummary: {
      mood: 'Mostly okay (Steady baseline)',
      stress: 'Higher than usual (Evening peaks noted)',
      energy: 'Improving (Morning rebound)',
      sleep: 'Needs attention (Interrupted rest)'
    }
  };
};

module.exports = {
  generateAiChatResponse,
  generateInsightFromSignals,
  generatePreConsultDigest
};
