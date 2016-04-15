component accessors="true"{

  property name="_id" type="string";
  property name="_type" type="string";
  property name="name" type="string";
  property name="password" type="string";
  property name="token" type="string";
  property name="flights" type="array";

  variables['_id'] = "";
  variables['_type'] = "";
  variables['name'] = "";
  variables['password'] = "";
  variables['token'] = "";
  variables['flights'] = [];

  /**
 * User Initialization
 */
  public User function init() {
    return this;
  }

  /**
 * Override the setName accessor to ensure the name is always lowercased
 * @value The value to set for the name
 */
  public void function setName( required string value ) {
    variables['name'] = lCase( arguments.value );
    return;
  }

  /**
 * Lookup a user by their name
 * @user The user to lookup
 * @inflate A boolean indicating whether or not the result should be inflated to a new User
 */
  public array function findByName( required string user, boolean inflate=false ) {
    var options = {
      designDocumentName: "user",
      viewName: "findByName",
      options: {
        limit: 1,
        key: lCase( arguments.user ),
        reduce: false,
        includeDocs: true,
        stale: "FALSE"
      }
    };
    if (arguments.inflate) {
      options['inflateTo'] = "models.User";
    }
    return application.couchbase.query( argumentCollection=options );
  }

  /**
  * Adds flights to a users record
  * @flights An array flights to add to the user
  */
  public void function addFlights( required array flights ) {
    var flight = "";
    for (var leg in arguments.flights) {
      flight = new Flight();
      flight.setName( leg._data.name );
      flight.setFlight( leg._data.flight );
      flight.setDate( leg._data.date );
      flight.setSourceAirport( leg._data.sourceairport );
      flight.setDestinationAirport( leg._data.destinationairport );
      flight.setBookedOn( now().getTime() );
      arrayAppend( variables.flights, flight );
    }
    return;
  }

  /**
  * Saves the users record back to Couchbase
  */
  public void function save() {
    // make sure there is an _id
    if (!len( variables._id )) {
      variables['_id'] = "User|" & lCase( createUUID() );
    }
    // always set the type
    variables['_type'] = "User";
    application.couchbase.set( id=variables._id, value=this );
    return;
  }

}
