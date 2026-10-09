const express = require('express');
const router = express.Router();
const checkinController = require('../controllers/checkinController');
const authMiddleware = require('../middleware/auth');

router.post('/', authMiddleware, checkinController.createCheckin);
router.get('/history', authMiddleware, checkinController.getHistory);
router.get('/progress', authMiddleware, checkinController.getProgress);

module.exports = router;
