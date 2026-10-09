const store = require('../models/store');

const getFamily = (req, res) => {
  return res.json({
    success: true,
    familyCircle: store.familyCircle
  });
};

const inviteFamilyMember = (req, res) => {
  const { name, relation, phone, permissions } = req.body;
  const newMember = {
    id: 'fam_' + Date.now(),
    name: name || 'Family Member',
    relation: relation || 'Companion',
    phone: phone || '',
    status: 'Connected',
    sharedPermissions: permissions || {
      wellbeingCheckins: false,
      goalsAndProgress: false,
      careSchedule: false,
      careSummaries: false,
      healthRecords: false
    }
  };

  store.familyCircle.members.push(newMember);
  return res.status(201).json({
    success: true,
    message: 'Invitation sent and member added.',
    member: newMember
  });
};

const updateMemberPermissions = (req, res) => {
  const { memberId, permissions } = req.body;
  const member = store.familyCircle.members.find(m => m.id === memberId) || store.familyCircle.members[0];
  
  if (permissions) {
    Object.assign(member.sharedPermissions, permissions);
  }

  return res.json({
    success: true,
    message: 'Permissions updated successfully.',
    member
  });
};

module.exports = {
  getFamily,
  inviteFamilyMember,
  updateMemberPermissions
};
