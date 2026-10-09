const express = require('express');
const router = express.Router();
const recordsController = require('../controllers/recordsController');
const authMiddleware = require('../middleware/auth');

router.get('/', authMiddleware, recordsController.getRecords);
router.post('/', authMiddleware, recordsController.addRecord);
router.patch('/:id/permissions', authMiddleware, recordsController.updateRecordPermissions);

module.exports = router;
