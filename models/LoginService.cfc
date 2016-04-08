component{

  property name="user" inject="User";
  /**
  *
  * @param username
  * @param password
  */
  public struct function createLogin(required string username, required string password){
    arguments['username'] = lCase(arguments.username);
    var lookup = user.findByName(arguments.username);
    // make sure the user doesn't already exist
    if(!arrayLen(lookup)){
      // set the user properties
      user.setName(arguments.username);
      user.setPassword(arguments.password);
      user.setToken(lCase(createUUID()));
      user.setFlights([]);
      // save the document
      user.save();
      return {"success": user.getToken()};
    }
    else{
      return {"failure": "User exists, please choose a different username"};
    }
  }
  /**
  *
  * @param username
  * @param password
  */
  public struct function authLogin(required string username, required string password){
    arguments['username'] = lCase(arguments.username);
    var lookup = user.findByName(arguments.username);
    // make sure the user doesn't already exist
    if(arrayLen(lookup)){
      if (arguments.password == lookup[1].document.password) {
        return {"success": lookup[1].document.token};
      }
      else {
        return {"failure": "Bad Username or Password"};
      }
    }
    else {
      return {"failure": "Bad Username or Password"};
    }
  }

}