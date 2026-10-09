const express = require('express');
const router = express.Router();
const goalController = require('../controllers/goalController');
const authMiddleware = require('../middleware/auth');

router.get('/', authMiddleware, goalController.getGoals);
router.post('/active', authMiddleware, goalController.updateActiveGoal);
router.post('/adapt', authMiddleware, goalController.adaptGoalSize);

module.exports = router;
