const express = require('express');
const router = express.Router();
const careController = require('../controllers/careController');
const authMiddleware = require('../middleware/auth');

router.get('/overview', authMiddleware, careController.getCareOverview);
router.get('/doctor', authMiddleware, careController.getCareProfessional);
router.post('/doctor/connect', authMiddleware, careController.connectCareProfessional);
router.get('/appointments', authMiddleware, careController.getAppointments);
router.post('/appointments/questions', authMiddleware, careController.addAppointmentQuestion);
router.get('/pre-consult', authMiddleware, careController.getPreConsultSummary);
router.post('/pre-consult/approve', authMiddleware, careController.approvePreConsultSummary);

module.exports = router;
