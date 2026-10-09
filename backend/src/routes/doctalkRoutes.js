const express = require('express');
const router = express.Router();
const doctalkController = require('../controllers/doctalkController');
const authMiddleware = require('../middleware/auth');

router.get('/care-types', doctalkController.getCareTypes);
router.get('/professionals', doctalkController.getProfessionals);
router.get('/professionals/:id', doctalkController.getProfessionalById);
router.get('/professionals/:id/slots', doctalkController.getAvailableSlots);
router.get('/offer-eligibility', authMiddleware, doctalkController.getOfferEligibility);
router.post('/book', authMiddleware, doctalkController.bookAppointment);
router.post('/appointments/:id/reschedule', authMiddleware, doctalkController.rescheduleAppointment);
router.post('/appointments/:id/cancel', authMiddleware, doctalkController.cancelAppointment);
router.get('/appointments', authMiddleware, doctalkController.getDocTalkAppointments);
router.get('/care-plans', authMiddleware, doctalkController.getCarePlans);
router.post('/care-plans/:id/adopt-goal', authMiddleware, doctalkController.adoptCarePlanGoal);

module.exports = router;
