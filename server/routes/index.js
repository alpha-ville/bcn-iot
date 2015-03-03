var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res) {
  res.header("Cache-Control", "no-cache, no-store, must-revalidate");
  res.header("Pragma", "no-cache");
  res.header("Expires", 0);
  
  res.render('index', { title: 'BCN IoT' });
});

module.exports = router;
