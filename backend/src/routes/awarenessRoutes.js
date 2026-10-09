const express = require('express');
const router = express.Router();
const awarenessController = require('../controllers/awarenessController');
const authMiddleware = require('../middleware/auth');

router.get('/', authMiddleware, awarenessController.getArticles);
router.get('/:id', authMiddleware, awarenessController.getArticleById);
router.post('/:id/save', authMiddleware, awarenessController.toggleSaveArticle);

module.exports = router;
