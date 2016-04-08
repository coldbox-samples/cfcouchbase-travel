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

  public array function findByName(required string user){
    var results = application.couchbase.query(
      designDocumentName='user',
      viewName='findByName',
      options = {
        limit: 1,
        key: arguments.user,
        reduce: false,
        includeDocs: true
      });
    return results;
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