﻿component extends="coldbox.system.EventHandler"{
    event.setView( "main/index" );
  }





    var sessionScope = event.getValue( "sessionReference" );
    var applicationScope = event.getValue( "applicationReference" );
  }
    //Grab Exception From private request collection, placed by ColdBox Exception Handling
    //Grab missingTemplate From request collection, placed by ColdBox
