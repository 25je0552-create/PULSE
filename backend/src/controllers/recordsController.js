const store = require('../models/store');

const getRecords = (req, res) => {
  const { category } = req.query;
  let items = store.healthRecords;
  if (category && category !== 'All') {
    items = items.filter(r => r.category.toLowerCase() === category.toLowerCase());
  }

  return res.json({
    success: true,
    totalRecords: store.healthRecords.length,
    careNotesCount: store.healthRecords.filter(r => r.category === 'Care documents').length,
    lastUpdated: '18 Sep 2026',
    categories: [
      { name: 'Care documents', description: 'Consultation notes & care summaries', count: 2 },
      { name: 'Reports & results', description: 'Health reports and diagnostic results', count: 1 },
      { name: 'Prescriptions', description: 'Medication information stored by you', count: 1 },
      { name: 'Wellbeing history', description: 'Pulse check-ins and monthly rhythm', count: 1 },
      { name: 'Appointments', description: 'Past and upcoming care summaries', count: 1 }
    ],
    records: items
  });
};

const addRecord = (req, res) => {
  const { title, subtitle, category, type, facility, details } = req.body;
  const newRec = {
    id: 'rec_' + Date.now(),
    title: title || 'New Health Document',
    subtitle: subtitle || 'Uploaded by patient',
    category: category || 'Care documents',
    type: type || 'Patient Record',
    date: new Date().toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' }),
    facility: facility || 'Personal Upload',
    details: details || '',
    sharedWithDoctor: false,
    sharedWithFamily: false
  };

  store.healthRecords.unshift(newRec);
  return res.status(201).json({
    success: true,
    record: newRec
  });
};

const updateRecordPermissions = (req, res) => {
  const { id } = req.params;
  const { sharedWithDoctor, sharedWithFamily } = req.body;
  const rec = store.healthRecords.find(r => r.id === id);
  if (!rec) {
    return res.status(404).json({ success: false, message: 'Record not found' });
  }

  if (sharedWithDoctor !== undefined) rec.sharedWithDoctor = sharedWithDoctor;
  if (sharedWithFamily !== undefined) rec.sharedWithFamily = sharedWithFamily;

  return res.json({
    success: true,
    record: rec
  });
};

module.exports = {
  getRecords,
  addRecord,
  updateRecordPermissions
};
