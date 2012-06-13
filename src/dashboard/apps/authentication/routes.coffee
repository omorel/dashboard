mongoose_user = require('../../models/user')
User = mongoose_user.User
UserSchema = mongoose_user.UserSchema

routes = (app) ->
  app.post '/login', (req, res) ->
    
    # Validate inputs
    req.assert('login', 'Please enter a valid login').len(2, 120).is(/[a-z0-9_]+/i)
    req.assert('password', 'Please enter a valid password').len(6, 120)

    errors = req.validationErrors(true)
    
    result = 
      result: 'NOK'
      errors: errors
    
    
    # If inputs are valid 
    if not errors 
      # Sanitize inputs 
      req.sanitize('login').xss()
      req.sanitize('password').trim()
    
      # Get values from the request
      password = req.body.password 
      login = req.body.login 
    
      User.findOne {login: login}, (err, user_doc) -> 
        if user_doc?
          console.log app.settings.salt
          hashed_password = mongoose_user.generate_password password, user_doc.salt, app.settings.salt
      
          if hashed_password is user_doc.hash 
            result.result = 'OK'
            result.message = 'logged in as user'
              
          else 
            console.log 'invalid password'
            result.message = 'invalid username/password'
        else 
          console.log 'invalid username'
          result.message =  'invalid username'      
    else 
      result.message = 'not-valid'
          
    res.json result 
          

  app.del '/sessions', (req, res) ->
    req.session.regenerate (err) ->
      req.flash 'info', 'You have been logged out.'
      res.redirect '/login'
      
      
  app.get '/login', (req, res) ->
    

module.exports = routes

