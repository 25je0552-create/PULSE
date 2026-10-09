const express = require('express');
const router = express.Router();
const wellbeingController = require('../controllers/wellbeingController');
const authMiddleware = require('../middleware/auth');

router.get('/', authMiddleware, wellbeingController.getWellbeingHub);
router.post('/reflection', authMiddleware, wellbeingController.saveReflection);

module.exports = router;
