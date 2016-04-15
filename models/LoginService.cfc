component{

  property name="user" inject="User";

  /**
 * LoginService Initialization
 */
  public LoginService function init() {
    return this;
  }

  /**
  * Creates a new user
  * @username The name of the user
  * @password An md5 hash of the password
  */
  public struct function createLogin ( required string username, required string password ) {
    var lookup = user.findByName( arguments.username );
    // make sure the user doesn't already exist
    if (!arrayLen( lookup )) {
      // set the user properties
      user.setName( arguments.username );
      user.setPassword( arguments.password );
      // just base64 the username as the token, this should probably be JWT at some point
      user.setToken( toBase64( arguments.username ) );
      user.setFlights( [] );
      // save the document
      user.save();
      return { "success": user.getToken() };
    }
    else {
      return { "failure": "User exists, please choose a different username" };
    }
  }
  /**
  * Authenticates an existing user
  * @username The name of the user
  * @password An md5 hash of the password
  */
  public struct function authLogin ( required string username, required string password ) {
    var lookup = user.findByName( arguments.username );
    // make sure the user was found
    if (arrayLen( lookup )) {
      if (arguments.password == lookup[1].document.password) {
        return { "success": lookup[1].document.token };
      }
      else {
        return { "failure": "Bad Username or Password" };
      }
    }
    else {
      return { "failure": "Bad Username or Password" };
    }
  }

}