const express = require('express');
const router = express.Router();
const store = require('../models/store');

router.get('/trusted-contact', (req, res) => {
  return res.json({
    success: true,
    trustedContact: store.familyCircle.trustedContact,
    careLead: {
      name: store.careTeam.partner.name,
      title: store.careTeam.partner.title,
      organization: store.careTeam.partner.organization
    },
    emergencyHelplines: [
      {
        name: 'Tele-MANAS (Mental Health Helpline)',
        number: '14416 / 1800 891 4416',
        hours: '24/7 Toll-free'
      },
      {
        name: 'KIRAN National Mental Health Helpline',
        number: '1800-599-0019',
        hours: '24/7'
      },
      {
        name: 'National Emergency Number',
        number: '112',
        hours: '24/7'
      }
    ]
  });
});

module.exports = router;
