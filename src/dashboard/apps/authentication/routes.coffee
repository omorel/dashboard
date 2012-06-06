mongoose_user = require('../../models/user')
User = mongoose_user.User
UserSchema = mongoose_user.UserSchema

routes = (app) ->

  app.post '/login', (req, res) ->
    
    password = req.body.password 
    user = req.body.login 
    
    user = User.findOne {login: 'oml'}, (err, doc) -> 
      console.log user 
      

  app.del '/sessions', (req, res) ->
    req.session.regenerate (err) ->
      req.flash 'info', 'You have been logged out.'
      res.redirect '/login'
      
      
  app.get '/login', (req, res) ->
    

module.exports = routes

