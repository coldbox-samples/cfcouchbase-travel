component{

  property name="user" inject="User";
  /**
  *
  * @param username
  * @param flights
  */
  public struct function bookFlights( required string username, required array flights ) {
    var lookup = user.findByName(arguments.username, true);
    // make sure the user doesn't already exist
    if (arrayLen( lookup )) {
      user = lookup[1].document;
      user.addFlights( arguments.flights );
      user.save();
      return { "added": arrayLen( arguments.flights ) };
    }
    else {
      return { "failure": "User not found" };
    }
  }
  /**
  *
  * @param username
  */
  public array function getFlights( required string username ){
    var lookup = user.findByName(arguments.username, true);
    var ret = [];
    // make sure the user was found
    if (arrayLen( lookup )) {
      ret = lookup[1].document.getFlights();
    }
    return ret;
  }

}