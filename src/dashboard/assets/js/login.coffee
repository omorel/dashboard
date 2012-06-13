jQuery (jQ) -> 

  jQ('#login-form a.login').unbind() 
  
  jQ('#login-form a.login').bind 'click', () -> 
    console.log 'test'
    jQ.ajax 
      type: 'POST'
      url: '/login' 
      cache: false
      dataType: 'json'
      timeout: 5000
      data: 
        login: $('#login-form-login').val()
        password: $('#login-form-password').val()
      
      success: (data, textStatus, jqXHR) -> 
        alert 'success'
      error: (jqXHR, textStatus, errorThrown) -> alert 'error'