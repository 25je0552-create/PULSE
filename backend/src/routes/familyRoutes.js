const express = require('express');
const router = express.Router();
const familyController = require('../controllers/familyController');
const authMiddleware = require('../middleware/auth');

router.get('/', authMiddleware, familyController.getFamily);
router.post('/invite', authMiddleware, familyController.inviteFamilyMember);
router.patch('/permissions', authMiddleware, familyController.updateMemberPermissions);

module.exports = router;
