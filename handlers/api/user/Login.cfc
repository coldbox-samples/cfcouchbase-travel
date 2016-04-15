component extends="coldbox.system.EventHandler"{

  // Inject a virtual service layer binded to the contact entity
  property name="login" inject="LoginService";

  // login Action
  function index ( event, rc, prc ) {
    var res = { "login":"bad request" };
    // make sure there is a user and password
    if(structKeyExists( arguments.rc, "user" ) && structKeyExists( arguments.rc, "password" )){
      res = login.authLogin( arguments.rc.user, arguments.rc.password) ;
    }
    event.renderData( type="json", data=res );
  }

  // create Action
  function create  (event, rc, prc ) {
    var res = { "login":"bad request" };
    var input = arguments.rc;
    var data = {};
    var body = toString( event.getHTTPContent() );
    if(isJSON( body )){
      structAppend( input, deserializeJSON( body ) );
    }
    // make sure there is a user and password
    if(structKeyExists( input, "user" ) && structKeyExists( input, "password" )){
      res = login.createLogin( input.user, input.password );
    }
    event.renderData( type="json", data=res );
  }

}