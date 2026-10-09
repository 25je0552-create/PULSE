const express = require('express');
const router = express.Router();
const aiController = require('../controllers/aiController');
const authMiddleware = require('../middleware/auth');

router.post('/chat', authMiddleware, aiController.chat);
router.get('/chat/history', authMiddleware, aiController.getChatHistory);
router.get('/insight', authMiddleware, aiController.getInsight);
router.get('/summary', authMiddleware, aiController.getSummary);

module.exports = router;
