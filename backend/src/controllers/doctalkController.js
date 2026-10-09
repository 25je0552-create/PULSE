const store = require('../models/store');

const getCareTypes = (req, res) => {
  return res.json({
    success: true,
    careTypes: store.careTypes
  });
};

const getProfessionals = (req, res) => {
  const { careType, specialty, mode, search, maxPrice } = req.query;
  let list = [...store.healthcareProfessionals];

  if (careType && careType !== 'All') {
    list = list.filter(p => p.careTypes.includes(careType));
  }

  if (specialty && specialty !== 'All') {
    list = list.filter(p => p.specialties.some(s => s.toLowerCase().includes(specialty.toLowerCase())));
  }

  if (mode && mode !== 'All') {
    list = list.filter(p => p.modes.some(m => m.toLowerCase().includes(mode.toLowerCase())));
  }

  if (maxPrice) {
    const max = parseFloat(maxPrice);
    if (!isNaN(max)) {
      list = list.filter(p => p.fee <= max);
    }
  }

  if (search) {
    const q = search.toLowerCase();
    list = list.filter(p =>
      p.name.toLowerCase().includes(q) ||
      p.role.toLowerCase().includes(q) ||
      p.clinicOrOrg.toLowerCase().includes(q) ||
      p.specialties.some(s => s.toLowerCase().includes(q))
    );
  }

  return res.json({
    success: true,
    total: list.length,
    professionals: list
  });
};

const getProfessionalById = (req, res) => {
  const { id } = req.params;
  const pro = store.healthcareProfessionals.find(p => p.id === id);
  if (!pro) {
    return res.status(404).json({
      success: false,
      message: 'Healthcare professional not found'
    });
  }
  return res.json({
    success: true,
    professional: pro
  });
};

const getAvailableSlots = (req, res) => {
  const { id } = req.params;
  const { date } = req.query;
  const pro = store.healthcareProfessionals.find(p => p.id === id);
  if (!pro) {
    return res.status(404).json({
      success: false,
      message: 'Healthcare professional not found'
    });
  }

  let slots = pro.availableSlots.filter(s => !s.isBooked);
  if (date) {
    slots = slots.filter(s => s.date === date);
  }

  return res.json({
    success: true,
    slots
  });
};

const getOfferEligibility = (req, res) => {
  const userId = req.user?.id || 'usr_patient_1';
  const offer = store.introductoryOffer;

  if (!offer || !offer.enabled) {
    return res.json({
      success: true,
      eligible: false,
      message: 'Introductory offer is currently inactive.',
      offer: null
    });
  }

  const alreadyRedeemed = store.offerRedemptions.some(
    r => r.userId === userId && r.offerId === offer.id
  );

  return res.json({
    success: true,
    eligible: !alreadyRedeemed,
    message: alreadyRedeemed
      ? 'Introductory offer already claimed.'
      : 'Eligible for 1st consultation complimentary offer.',
    offer: !alreadyRedeemed ? offer : null
  });
};

const bookAppointment = (req, res) => {
  const userId = req.user?.id || 'usr_patient_1';
  const {
    professionalId,
    slotId,
    date,
    time,
    mode,
    reason,
    sharePreConsultSummary,
    shareRecords,
    applyIntroductoryOffer
  } = req.body;

  if (!professionalId || !date || !time) {
    return res.status(400).json({
      success: false,
      message: 'Professional, date, and time slot are required for booking.'
    });
  }

  const pro = store.healthcareProfessionals.find(p => p.id === professionalId);
  if (!pro) {
    return res.status(404).json({
      success: false,
      message: 'Professional not found.'
    });
  }

  let matchedSlot = null;
  if (slotId) {
    matchedSlot = pro.availableSlots.find(s => s.id === slotId);
  } else {
    matchedSlot = pro.availableSlots.find(s => s.date === date && s.time === time && !s.isBooked);
  }

  if (matchedSlot && matchedSlot.isBooked) {
    return res.status(409).json({
      success: false,
      message: 'The selected slot has already been reserved. Please select another time.'
    });
  }

  let discount = 0;
  let finalFee = pro.fee;
  const isOfferEligible = !store.offerRedemptions.some(
    r => r.userId === userId && r.offerId === store.introductoryOffer.id
  );

  if (applyIntroductoryOffer && store.introductoryOffer.enabled && isOfferEligible) {
    discount = pro.fee;
    finalFee = 0;
    store.offerRedemptions.push({
      id: 'red_' + Date.now(),
      userId,
      offerId: store.introductoryOffer.id,
      professionalId,
      redeemedAt: new Date().toISOString()
    });
  }

  if (matchedSlot) {
    matchedSlot.isBooked = true;
  }

  const newAppointment = {
    id: 'apt_' + Date.now(),
    title: 'Consultation with ' + pro.name,
    doctorName: pro.name,
    organization: pro.clinicOrOrg,
    format: mode || 'Video Consultation',
    date,
    time,
    duration: '45 min',
    isVirtual: (mode || 'Video Consultation').toLowerCase().includes('video') ||
               (mode || 'Video Consultation').toLowerCase().includes('audio'),
    status: 'Confirmed',
    venue: mode || 'Video Consultation',
    notesReady: false,
    questions: reason ? [reason] : [],
    source: 'DocTalk',
    professionalId: pro.id,
    sharedContext: {
      preConsultSummaryShared: sharePreConsultSummary === true,
      recordsSharedCount: Array.isArray(shareRecords) ? shareRecords.length : 0
    },
    paymentSummary: {
      originalFee: pro.fee,
      discount,
      finalFee,
      isDemoBooking: true
    }
  };

  store.appointments.unshift(newAppointment);

  return res.status(201).json({
    success: true,
    message: 'Consultation confirmed successfully.',
    appointment: newAppointment
  });
};

const rescheduleAppointment = (req, res) => {
  const { id } = req.params;
  const { newDate, newTime, newSlotId } = req.body;

  const appt = store.appointments.find(a => a.id === id);
  if (!appt) {
    return res.status(404).json({
      success: false,
      message: 'Appointment not found.'
    });
  }

  if (newDate) appt.date = newDate;
  if (newTime) appt.time = newTime;
  appt.status = 'Rescheduled';

  return res.json({
    success: true,
    message: 'Appointment rescheduled successfully.',
    appointment: appt
  });
};

const cancelAppointment = (req, res) => {
  const { id } = req.params;
  const appt = store.appointments.find(a => a.id === id);
  if (!appt) {
    return res.status(404).json({
      success: false,
      message: 'Appointment not found.'
    });
  }

  appt.status = 'Cancelled';
  return res.json({
    success: true,
    message: 'Appointment cancelled successfully.',
    appointment: appt
  });
};

const getDocTalkAppointments = (req, res) => {
  const nowStr = new Date().toISOString().split('T')[0];
  const upcoming = store.appointments.filter(a => a.status !== 'Cancelled' && a.status !== 'Completed');
  const past = store.appointments.filter(a => a.status === 'Cancelled' || a.status === 'Completed');

  return res.json({
    success: true,
    upcoming,
    past
  });
};

const getCarePlans = (req, res) => {
  return res.json({
    success: true,
    carePlans: store.carePlans
  });
};

const adoptCarePlanGoal = (req, res) => {
  const { id } = req.params;
  const { recommendationId } = req.body;

  const plan = store.carePlans.find(cp => cp.id === id);
  if (!plan) {
    return res.status(404).json({
      success: false,
      message: 'Care plan not found.'
    });
  }

  const rec = plan.recommendations.find(r => r.id === recommendationId);
  if (!rec) {
    return res.status(404).json({
      success: false,
      message: 'Recommendation not found.'
    });
  }

  rec.adoptedAsGoal = true;

  if (store.goals && Array.isArray(store.goals.active)) {
    const existing = store.goals.active.find(g => g.title === rec.title);
    if (!existing) {
      store.goals.active.push({
        id: 'goal_' + Date.now(),
        title: rec.title,
        description: rec.description,
        category: rec.category,
        durationMinutes: rec.durationMinutes || 15,
        frequency: rec.frequency || 'Daily',
        difficulty: 'Easy',
        isActive: true,
        source: 'Doctor Prescribed Advice (' + plan.professionalName + ')'
      });
    }
  }

  return res.json({
    success: true,
    message: 'Recommendation adopted into active Pulse Goals.',
    recommendation: rec
  });
};

module.exports = {
  getCareTypes,
  getProfessionals,
  getProfessionalById,
  getAvailableSlots,
  getOfferEligibility,
  bookAppointment,
  rescheduleAppointment,
  cancelAppointment,
  getDocTalkAppointments,
  getCarePlans,
  adoptCarePlanGoal
};
