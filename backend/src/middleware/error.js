const errorHandler = (err, req, res, next) => {
  const statusCode = res.statusCode === 200 ? 500 : res.statusCode;
  return res.status(statusCode).json({
    success: false,
    message: err.message || 'An unexpected error occurred in Pulse service.'
  });
};

module.exports = errorHandler;
