const express = require('express');
const router = express.Router();
const patientController = require('../controllers/patientController');
const authMiddleware = require('../middleware/auth');

router.get('/profile', authMiddleware, patientController.getProfile);
router.patch('/profile', authMiddleware, patientController.updateProfile);
router.post('/baseline', authMiddleware, patientController.saveBaseline);
router.get('/home', authMiddleware, patientController.getHome);

module.exports = router;
