component{

  property name="user" inject="User";

  /**
  * BookingService Initialization
  */
  public BookingService function init () {
    return this;
  }

  /**
  * Books flights for a user
  * @username The user to book the flights for
  * @flights An array of flights to book for the user
  */
  public struct function bookFlights ( required string username, required array flights ) {
    var lookup = user.findByName( user=arguments.username, inflate=true);
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
  * Gets all of a users flights
  * @username The user to get the flights for
  */
  public array function getFlights ( required string username ) {
    var lookup = user.findByName( user=arguments.username, inflate=true );
    var ret = [];
    // make sure the user was found
    if (arrayLen( lookup )) {
      ret = lookup[1].document.getFlights();
    }
    return ret;
  }

}