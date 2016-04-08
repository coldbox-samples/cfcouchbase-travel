component extends="coldbox.system.EventHandler"{

  // Inject a virtual service layer binded to the contact entity
  property name="airport" inject="airport";

  // Default Action
  function index(event, rc, prc){
    var res = {"airport":"bad request"};
    var data = {};
    // make sure there is a search term
    if(structKeyExists(arguments.rc, "search")){
      data = airport.findAll(arguments.rc.search);
      res = data.results;
    }
    event.renderData( type="json", data=res );
  }

}