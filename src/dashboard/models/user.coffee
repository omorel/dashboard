mongoose = require('mongoose'); 

generate_salt = (length=32) ->
  
  generate_letter = () ->  
    rnd = parseInt(Math.random() * 1000)
    String.fromCharCode((rnd % 34) + 33)
    
  (generate_letter() for i in [1..length])
  
generate_password = (password, user_salt, main_salt) -> 
  console.log HashGenerator.hex (password + user_salt + main_salt) 

UserSchema = new mongoose.Schema 
  firstname: 
    type: String
    index: true
    required: true    
  lastname: 
    type: String
    index: true 
    required: true    
  email: 
    type: String
    index: true
    unique: true
    required: true    
  salt: 
    type: String
    required: true
    default: -> 
      generate_salt()
  hash: 
    type: String
    required: true
  status: 
    type: String
    enum: ['new', 'active', 'disabled']
    default: true
    required: true
  login: 
    type: String
    unique: true
    lowercase: true
    required: true
  image: 
    type: String 
    
User = mongoose.model 'User', UserSchema 



module.exports = 
  User: User 
  UserSchema: UserSchema
  generate_password: generate_password