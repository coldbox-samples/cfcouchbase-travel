component{

  property name="name" type="string";
  property name="flight" type="string";
  property name="date" type="string";
  property name="sourceairport" type="string";
  property name="destinationairport" type="string";
  property name="bookedon" type="string";

  // create Action
  public User function init(){
    variables['name'] = "";
    variables['flight'] = "";
    variables['date'] = "";
    variables['sourceairport'] = "";
    variables['destinationairport'] = "";
    variables['bookedon'] = "";
    return this;
  }

}