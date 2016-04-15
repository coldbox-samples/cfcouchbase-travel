component accessors="true"{

  property name="name" type="string";
  property name="flight" type="string";
  property name="date" type="string";
  property name="sourceairport" type="string";
  property name="destinationairport" type="string";
  property name="bookedon" type="string";


  variables['name'] = "";
  variables['flight'] = "";
  variables['date'] = "";
  variables['sourceairport'] = "";
  variables['destinationairport'] = "";
  variables['bookedon'] = "";

  /**
  * Flight Initialization
  */
  public Flight function init () {
    return this;
  }

}