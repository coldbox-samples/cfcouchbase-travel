component extends="coldbox.system.EventHandler"{

  // Inject a virtual service layer binded to the contact entity
  property name="book" inject="BookingService";

  // listing Action
  function index(event, rc, prc){
    var res = { "book":"bad request" };
    // make sure there is a user and password
    if (structKeyExists( arguments.rc, "token" )) {
      res = book.getFlights( toString( toBinary( arguments.rc.token ) ) );
    }
    event.renderData( type="json", data=res );
  }

  // book flights
  function reserve(event, rc, prc){
    var res = { "book":"bad request" };
    var input = arguments.rc;
    var data = {};
    var body = toString( event.getHTTPContent() );
    if (isJSON( body )) {
      structAppend( input, deserializeJSON( body ) );
    }
    // make sure there is a user and flights
    if (structKeyExists( input, "token" ) && structKeyExists( input, "flights" ) && isArray( input.flights )) {
      res = book.bookFlights( toString( toBinary( input.token ) ), input.flights);
    }
    event.renderData( type="json", data=res );
  }

}