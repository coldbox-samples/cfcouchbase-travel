component extends="coldbox.system.EventHandler"{

  // Inject a virtual service layer binded to the contact entity
  property name="flightPath" inject="flightPath";

  // Default Action
  function index(event, rc, prc){
    var res = {"flightPath":"bad request"};
    var data = {};
    // make sure there is a search term
    if(structKeyExists(arguments.rc, "to") && structKeyExists(arguments.rc, "from") && structKeyExists(arguments.rc, "leave")){
      data = flightPath.findAll(argumentCollection=arguments.rc);
      res = data;
    }
    event.renderData( type="json", data=res );
  }

}