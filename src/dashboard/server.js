require('coffee-script');

/**
 * Module dependencies.
 */

var express = require('express')
  , routes = require('./routes')
  , less = require('less')
  , RedisStore = require('connect-redis')(express)
  , mongoose = require('mongoose')
  , Hashes = require('jshashes');

require('express-namespace');

var app = module.exports = express.createServer();

var socket_io = require('socket.io').listen(app);
 
// Configuration
app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.set('port', 3000);
  app.set('salt', 'dashboard'); 
  app.set('mongodb', {
    host: 'localhost', 
    port: 27017, 
    db_name: 'knowledge',
    dsn: 'mongodb://localhost/knowledge',
    parameters: {auto_reconnect: true}
  }); 
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser());
  app.use(require('express-validator'))
  app.use(express.session({
    secret: "abcdefghijklmnop",
    store: new RedisStore
  }));  
  app.use(app.router);
  app.use(require('connect-assets')())
  app.use(express.compiler({ src : __dirname + '/public', enable: ['less']}));    
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('production', function(){
  app.use(express.errorHandler());
});

app.configure('test', function() {
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true })); 
  app.set('port', 3030)
});

// Routes
app.get('/', routes.index);

// Add apps routes 
require('./apps/authentication/routes')(app);

// Connect to mongodb database 
mongoose.connect(app.settings.mongodb.dsn);

// Create Hash generator 
HashGenerator = new Hashes.SHA512 

app.listen(app.settings.port, function(){
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});
