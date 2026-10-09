const store = require('../models/store');

const getArticles = (req, res) => {
  const { category } = req.query;
  let items = store.awarenessLibrary;
  if (category && category !== 'All') {
    items = items.filter(i => i.category.toLowerCase() === category.toLowerCase());
  }
  return res.json({
    success: true,
    total: items.length,
    articles: items
  });
};

const getArticleById = (req, res) => {
  const { id } = req.params;
  const article = store.awarenessLibrary.find(a => a.id === id) || store.awarenessLibrary[0];
  return res.json({
    success: true,
    article
  });
};

const toggleSaveArticle = (req, res) => {
  const { id } = req.params;
  const article = store.awarenessLibrary.find(a => a.id === id);
  if (article) {
    article.isSaved = !article.isSaved;
    return res.json({ success: true, isSaved: article.isSaved });
  }
  return res.status(404).json({ success: false, message: 'Article not found' });
};

module.exports = {
  getArticles,
  getArticleById,
  toggleSaveArticle
};
