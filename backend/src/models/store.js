const bcrypt = require('bcryptjs');

const generateDemoCheckins = () => {
  const checkins = [];
  const now = new Date('2026-09-24T08:30:00Z');
  
  for (let i = 89; i >= 0; i--) {
    const d = new Date(now.getTime() - i * 24 * 60 * 60 * 1000);
    const dateStr = d.toISOString().split('T')[0];
    
    let mood = 'Okay';
    let stress = 'Moderate';
    let energy = 'Okay';
    let sleep = 'Fair';
    let sleepHours = 7.0;
    let goalDone = true;
    let note = '';

    if (i > 65) {
      mood = i % 2 === 0 ? 'Okay' : 'Low';
      stress = 'Moderate';
      energy = 'Low';
      sleep = 'Poor';
      sleepHours = 5.5;
      goalDone = i % 3 === 0;
      note = 'Adjusting to routines.';
    } else if (i > 45) {
      mood = 'Good';
      stress = 'Low';
      energy = 'Good';
      sleep = 'Good';
      sleepHours = 7.5;
      goalDone = true;
      note = 'Morning walk felt refreshing.';
    } else if (i > 20) {
      mood = 'Low';
      stress = 'High';
      energy = 'Low';
      sleep = 'Poor';
      sleepHours = 5.0;
      goalDone = i % 4 === 0;
      note = 'Work has been overwhelming this week.';
    } else if (i > 3) {
      mood = 'Okay';
      stress = 'Moderate';
      energy = 'Okay';
      sleep = 'Fair';
      sleepHours = 6.8;
      goalDone = true;
      note = '10-minute screen pause really helps midday.';
    } else if (i === 0) {
      mood = 'Okay';
      stress = 'High';
      energy = 'Low';
      sleep = 'Poorly';
      sleepHours = 5.5;
      goalDone = true;
      note = 'Work deadline today, energy dipping.';
    } else {
      mood = 'Okay';
      stress = 'Moderate';
      energy = 'Low';
      sleep = 'Poor';
      sleepHours = 6.0;
      goalDone = true;
      note = 'Focusing on one small habit.';
    }

    checkins.push({
      id: 'chk_' + (90 - i),
      date: dateStr,
      timestamp: d.toISOString(),
      mood,
      stress,
      energy,
      sleep,
      sleepHours,
      goalCompleted: goalDone,
      reflection: note,
      symptoms: stress === 'High' ? ['Tension headache', 'Fatigue'] : []
    });
  }
  return checkins;
};

const store = {
  users: [
    {
      id: 'usr_patient_1',
      name: 'Ananya Sharma',
      email: 'patient@pulse.health',
      phone: '+91 98765 43210',
      passwordHash: bcrypt.hashSync('pulse123', 8),
      role: 'patient',
      createdAt: '2026-08-01T09:00:00Z'
    },
    {
      id: 'usr_doctor_1',
      name: 'Dr. Meera Sharma',
      email: 'doctor@pulse.health',
      phone: '+91 98765 12345',
      passwordHash: bcrypt.hashSync('pulse123', 8),
      role: 'doctor',
      createdAt: '2026-07-01T09:00:00Z'
    }
  ],

  patientProfile: {
    id: 'pat_1',
    userId: 'usr_patient_1',
    patientCode: 'PLS-84920',
    fullName: 'Ananya Sharma',
    age: 24,
    gender: 'Female',
    city: 'Bengaluru',
    beachheadCondition: 'PCOS',
    memberSince: 'August 2026',
    activeCareTeamCount: 1,
    familyCount: 1,
    savedAwarenessCount: 4,
    conditions: [
      'PCOS',
      'Irregular Sleep Rhythms',
      'High Work Stress'
    ],
    supportGoals: [
      'Understand my wellbeing patterns',
      'Manage stress better',
      'Build healthier routines',
      'Stay consistent with my care'
    ],
    onboardingStep: 4,
    onboardingCompleted: true,
    privacyCommitments: {
      useDataToPersonalize: true,
      nonReplacementConsent: true,
      dataNeverSold: true,
      patientControlledDeletion: true
    }
  },

  checkins: generateDemoCheckins(),

  goals: [
    {
      id: 'goal_1',
      title: 'Take 10 minutes away from your work screen',
      description: 'Step away from work notifications, rest your eyes, or take a gentle pause without any agenda.',
      category: 'Screen Pause',
      durationMinutes: 10,
      frequency: 'Every day',
      preferredTime: 'Afternoon',
      difficulty: 'Easy',
      targetDays: 7,
      completedDays: 4,
      isActive: true,
      source: 'Pulse Adaptive Suggestion'
    },
    {
      id: 'goal_2',
      title: 'Take a 10-minute walk today',
      description: 'Gentle low-friction movement to reset your circulatory and nervous system.',
      category: 'Movement',
      durationMinutes: 10,
      frequency: '3 days a week',
      preferredTime: 'Morning',
      difficulty: 'Manageable',
      targetDays: 3,
      completedDays: 2,
      isActive: true,
      source: 'Care Plan Action'
    },
    {
      id: 'goal_3',
      title: 'Go to bed 20 minutes earlier',
      description: 'Support circadian winding down without sleep pressure.',
      category: 'Sleep',
      durationMinutes: 20,
      frequency: 'Every day',
      preferredTime: 'Evening',
      difficulty: 'Manageable',
      targetDays: 7,
      completedDays: 5,
      isActive: false,
      source: 'Adaptive Option'
    }
  ],

  careTeam: {
    connected: true,
    partner: {
      id: 'doc_1',
      name: 'Dr. Meera Sharma',
      title: 'Primary Care Professional',
      credentials: 'MD (Internal Medicine)',
      specialty: 'Integrated Family Medicine & Women\'s Health',
      organization: 'St. Jude Health Partner',
      partnerCode: 'SJH-4829',
      connectedSince: '12 Sep 2026',
      clinicLocation: 'St. Jude Health Center, Suite 304, Bengaluru',
      telehealthAvailable: true,
      sharingStatus: 'Patient Controlled Active',
      avatarUrl: ''
    },
    disciplines: [
      { name: 'Primary Care', connected: true, doctor: 'Dr. Meera Sharma' },
      { name: 'Therapist', connected: false, doctor: null },
      { name: 'Psychologist', connected: false, doctor: null },
      { name: 'Psychiatrist', connected: false, doctor: null }
    ]
  },

  appointments: [
    {
      id: 'apt_1',
      title: 'Routine Consultation',
      doctorName: 'Dr. Meera Sharma, MD',
      organization: 'St. Jude Health Center (Suite 304)',
      format: 'Routine Review & Care Plan Check-in',
      date: '2026-09-24',
      time: '11:30 AM',
      duration: '45 min',
      isVirtual: true,
      status: 'Confirmed',
      venue: 'St. Jude Health & Virtual Hybrid Option',
      notesReady: true,
      questions: [
        'Ask about recent sleep fragmentation and 10 AM energy dips',
        'Review evening screen pause effectiveness'
      ]
    },
    {
      id: 'apt_2',
      title: 'Initial Evaluation & Baseline',
      doctorName: 'Dr. Meera Sharma, MD',
      organization: 'St. Jude Health Center',
      format: 'Comprehensive Care Intake',
      date: '2026-09-12',
      time: '10:00 AM',
      duration: '45 min',
      isVirtual: false,
      status: 'Completed',
      venue: 'In-clinic Consultation',
      notesReady: false,
      questions: []
    }
  ],

  preConsultSummary: {
    id: 'pcs_1',
    appointmentId: 'apt_1',
    reviewWindow: '30d (12 Sep - 24 Sep 2026)',
    checkinsLogged: 6,
    activeGoals: 2,
    patternsNoticed: 1,
    isDraft: true,
    isApprovedByPatient: false,
    keyObservations: [
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
    },
    patientQuestions: [
      'Ask about recent sleep fragmentation and 10 AM energy dips',
      'Should we adjust afternoon meal timing?'
    ]
  },

  awarenessLibrary: [
    {
      id: 'aware_1',
      title: 'Understanding stress and your body',
      subtitle: 'Learn how stress affects your everyday nervous system and what healthy, sustainable coping strategies look like.',
      category: 'Mental wellbeing',
      duration: '4 min',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      thumbnailUrl: '',
      isFeatured: true,
      hasAudio: true,
      reviewedBy: 'Dr. Meera Sharma & Clinical Wellbeing Board',
      isSaved: true,
      takeaways: [
        {
          title: 'Notice your signals',
          body: 'Stress responses show up physiologically in heart rate variability, shallow breath patterns, and altered sleep cycles. Recognizing them is the first step.'
        },
        {
          title: 'Small responses matter',
          body: 'Micro-breaks, deliberate diaphragmatic breathing, and consistent downtime actively stimulate the vagal nerve and parasympathetic recovery.'
        },
        {
          title: 'Know when to reach out',
          body: 'If stress feels persistent or interrupts daily tasks, discuss it openly with someone you trust or consult your certified clinical practitioner.'
        }
      ]
    },
    {
      id: 'aware_2',
      title: 'Why restorative sleep matters',
      subtitle: 'Learn how sleep cycles connect with your daily energy baseline and emotional regulation.',
      category: 'Sleep',
      duration: '5 min',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      thumbnailUrl: '',
      isFeatured: false,
      hasAudio: true,
      reviewedBy: 'Clinical Sleep Advisory',
      isSaved: true,
      takeaways: [
        {
          title: 'Sleep rhythm consistency',
          body: 'Regular waking times stabilize your internal clock better than irregular weekend sleeping-in.'
        },
        {
          title: 'Light and evening cortisol',
          body: 'Reducing blue-spectrum lighting 45 minutes before resting supports natural melatonin synthesis.'
        }
      ]
    },
    {
      id: 'aware_3',
      title: 'Understanding PCOS & Everyday Wellbeing',
      subtitle: 'Demystifying insulin sensitivity, cyclic fluctuations, and non-stigmatized lifestyle pacing.',
      category: 'Care & consultations',
      duration: '6 min',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      thumbnailUrl: '',
      isFeatured: false,
      hasAudio: true,
      reviewedBy: 'Women\'s Endocrinology Panel',
      isSaved: true,
      takeaways: [
        {
          title: 'Whole-person approach',
          body: 'PCOS touches sleep, metabolic energy, and emotional state; small compassionate routines matter.'
        }
      ]
    },
    {
      id: 'aware_4',
      title: 'Micro-movement for sustained energy',
      subtitle: 'Sustainable 10-minute movement snacks that fit easily into seated desk schedules.',
      category: 'Movement',
      duration: '3 min',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      thumbnailUrl: '',
      isFeatured: false,
      hasAudio: false,
      reviewedBy: 'Physical Therapy Specialist',
      isSaved: true,
      takeaways: [
        {
          title: 'Gentle mobilization',
          body: 'Frequent light walking beats high intensity exhaustion when recovering from poor sleep.'
        }
      ]
    }
  ],

  healthRecords: [
    {
      id: 'rec_1',
      title: 'Consultation summary',
      subtitle: 'Dr. Meera Sharma · Primary Care',
      type: 'Clinician note',
      category: 'Care documents',
      date: '18 Sep 2026',
      facility: 'St. Jude Health Center',
      details: 'Follow-up regarding lifestyle pacing, sleep hygiene advice, and baseline metabolic monitoring.',
      sharedWithDoctor: true,
      sharedWithFamily: false
    },
    {
      id: 'rec_2',
      title: 'Comprehensive Metabolic Panel & Hormonal Baseline',
      subtitle: 'Bengaluru Diagnostic Laboratories',
      type: 'Lab report',
      category: 'Reports & results',
      date: '10 Sep 2026',
      facility: 'BDL Labs, Indiranagar',
      details: 'Insulin, lipid profile, thyroid function, and androgen indices reviewed with primary care doctor.',
      sharedWithDoctor: true,
      sharedWithFamily: false
    },
    {
      id: 'rec_3',
      title: 'Current Nutritional Care Guidelines',
      subtitle: 'Dr. Meera Sharma, MD',
      type: 'Care plan',
      category: 'Prescriptions',
      date: '12 Sep 2026',
      facility: 'St. Jude Health',
      details: 'Magnesium glycinate supplement guidance, balanced glycemic meals recommendation.',
      sharedWithDoctor: true,
      sharedWithFamily: false
    },
    {
      id: 'rec_4',
      title: 'Pulse 30-Day Check-in Synthesis',
      subtitle: 'Self-reported telemetry archive',
      type: 'Wellbeing history',
      category: 'Wellbeing history',
      date: '22 Sep 2026',
      facility: 'Pulse Encrypted Vault',
      details: 'Archive of self-reported mood, energy, and stress daily signals.',
      sharedWithDoctor: true,
      sharedWithFamily: true
    },
    {
      id: 'rec_5',
      title: 'Care Schedule Archive & Follow-up Plan',
      subtitle: 'Upcoming & Past appointments',
      type: 'Schedule',
      category: 'Appointments',
      date: '12 Sep 2026',
      facility: 'St. Jude Health',
      details: 'Scheduled routine check-in timeline.',
      sharedWithDoctor: true,
      sharedWithFamily: false
    }
  ],

  familyCircle: {
    members: [
      {
        id: 'fam_1',
        name: 'Priya',
        relation: 'Sister',
        phone: '+91 98111 22334',
        status: 'Connected',
        sharedPermissions: {
          wellbeingCheckins: true,
          goalsAndProgress: true,
          careSchedule: false,
          careSummaries: false,
          healthRecords: false
        }
      }
    ],
    trustedContact: {
      name: 'Sarah Jenkins',
      role: 'Designated Trusted Contact',
      phone: '+91 98222 33445',
      relationship: 'Close Friend'
    }
  },

  wellbeingReflections: [
    {
      id: 'ref_1',
      text: 'I\'ve been feeling overwhelmed with work lately.',
      date: '2026-09-24',
      savedLocally: true,
      isPrivate: true
    }
  ],

  aiChatHistory: [
    {
      id: 'msg_1',
      sender: 'user',
      text: 'Work has been overwhelming this week.',
      timestamp: '08:32 AM'
    },
    {
      id: 'msg_2',
      sender: 'pulse_ai',
      text: 'Taking brief moments to step back can give your nervous system a pause. Would you like a 2-minute breathing reset or ideas on setting gentle boundaries today?',
      timestamp: '08:33 AM'
    }
  ]
};

module.exports = store;
