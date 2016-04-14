component accessors="true"{

  property name="_id" type="string";
  property name="_type" type="string";
  property name="name" type="string";
  property name="password" type="string";
  property name="token" type="string";
  property name="flights" type="array";

  // create Action
  public User function init(){
    variables['_id'] = "";
    variables['_type'] = "";
    variables['name'] = "";
    variables['password'] = "";
    variables['token'] = "";
    variables['flights'] = [];
    return this;
  }

  public array function findByName(required string user, boolean inflate=false){
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
    return application.couchbase.query( argumentCollection=options );;
  }

  public void function addFlights( required array flights){
    var flight = "";
    for(var leg in arguments.flights){
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

  public void function save(){
    // make sure there is an _id
    if(!len(variables._id)){
      variables['_id'] = "User|" & lCase(createUUID());
    }
    // always set the type
    variables['_type'] = "User";
    application.couchbase.set(id=variables._id, value=this);
    return;
  }
}