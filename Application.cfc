/**
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
*/
component{
  // Application properties
  this.name = hash( getCurrentTemplatePath() );
  this.sessionManagement = true;
  this.sessionTimeout = createTimeSpan(0,0,30,0);
  this.setClientCookies = true;

  // COLDBOX STATIC PROPERTY, DO NOT CHANGE UNLESS THIS IS NOT THE ROOT OF YOUR COLDBOX APP
  COLDBOX_APP_ROOT_PATH = getDirectoryFromPath( getCurrentTemplatePath() );
  // The web server mapping to this application. Used for remote purposes or static purposes
  COLDBOX_APP_MAPPING   = "";
  // COLDBOX PROPERTIES
  COLDBOX_CONFIG_FILE    = "";
  // COLDBOX APPLICATION KEY OVERRIDE
  COLDBOX_APP_KEY      = "";
  // JAVA INTEGRATION: JUST DROP JARS IN THE LIB FOLDER
  // You can add more paths or change the reload flag as well.
  this.javaSettings = { loadPaths = [ "lib" ], reloadOnChange = false };

  this.mappings[ "/cfcouchbase" ] = expandPath( "modules/cfcouchbase" );

  // application start
  public boolean function onApplicationStart(){
    application.cbBootstrap = new coldbox.system.Bootstrap( COLDBOX_CONFIG_FILE, COLDBOX_APP_ROOT_PATH, COLDBOX_APP_KEY, COLDBOX_APP_MAPPING );
    application.cbBootstrap.loadColdbox();

    // create connection to couchbase cluster
    application['couchbase'] = new cfcouchbase.CouchbaseClient({
      servers		= "127.0.0.1",
      bucketname	= "travel-sample",
      caseSensitiveKeys = true
    });
    // create a view
    application.couchbase.asyncSaveView(
			'user',
			'findByName',
			'function (doc, meta) {
			  if(meta.id.indexOf("User|") != -1 && doc.name){
			    emit(doc.name, null);
			  }
			}',
			'_count'
		);
    return true;
  }

  /**
	* Runs when the application ends
	* @appScope the application scope
	*/
	public void function onApplicationEnd(required struct appScope){
		// if the couchbase connection is present close it's connections
		if(structKeyExists(arguments.appScope, "couchbase")){
			arguments.appScope.couchbase.shutdown(10);
		}
		return;
	}

  // request start
  public boolean function onRequestStart(string targetPage){
    // create a connection to the default bucket if it does not already exist
		if(!structKeyExists(application, "couchbase")){

		}
    application['couchbase'] = new cfcouchbase.CouchbaseClient({
      servers		= "127.0.0.1",
      bucketname	= "travel-sample",
      caseSensitiveKeys = true
    });
    // Process ColdBox Request
    application.cbBootstrap.onRequestStart( arguments.targetPage );

    return true;
  }

  public void function onSessionStart(){
    application.cbBootStrap.onSessionStart();
  }

  public void function onSessionEnd( struct sessionScope, struct appScope ){
    arguments.appScope.cbBootStrap.onSessionEnd( argumentCollection=arguments );
  }

  public boolean function onMissingTemplate( template ){
    return application.cbBootstrap.onMissingTemplate( argumentCollection=arguments );
  }

}