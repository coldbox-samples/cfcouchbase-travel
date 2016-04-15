component{

  /**
  * FlightPathService Initialization
  */
  public FlightPathService function init () {
    return this;
  }

  /**
 * Finds all of the available flights for a given route
 * @from The originating airport code
 * @to The destination airport code
 * @leave The date of the flight
 */
  public array function findAll ( required string from, required string to, required string leave ) {
    var ret = [];
    var bucketName = application.couchbase.getCouchbaseConfig().getBucketName();
    var queryPrep = "
      SELECT faa as fromAirport, geo
      FROM `" & bucketName & "`
      WHERE airportname = '" & arguments.from & "'
      UNION
      SELECT faa as toAirport, geo
      FROM `" & bucketName & "`
      WHERE airportname = '" & arguments.to & "'
    ";
    var result = application.couchbase.n1qlQuery(
      statement=queryPrep
    );
    if (result.success) {
      var queryTo = "";
      var queryFrom = "";
      var geoStart = {};
      var geoEnd = {};
      var flightTime = "";
      var price = 0;
      var distance = 0;

      for (var entry in result.results) {
        if (structKeyExists( entry, "toAirport" ) && len( entry.toAirport )) {
            queryTo = entry.toAirport;
            geoEnd = { longitude: entry.geo.lon, latitude: entry.geo.lat };
        }
        if (structKeyExists( entry, "fromAirport" ) && len( entry.fromAirport )) {
            queryFrom = entry.fromAirport;
            geoStart = { longitude: entry.geo.lon, latitude: entry.geo.lat };
        }
      }

      distance = haversine( geoStart, geoEnd );
      flightTime = round(distance / application.config.avgKmHr);
      price = round(distance * application.config.distanceCostMultiplier);

      queryPrep = "
        SELECT r.id, a.name, s.flight, s.utc, r.sourceairport, r.destinationairport, r.equipment
        FROM `" & bucketName & "` r
        UNNEST r.schedule s JOIN `" & bucketName & "` a ON KEYS r.airlineid
        WHERE r.sourceairport = '" & queryFrom & "' AND
              r.destinationairport = '" & queryTo & "' AND
              s.day = " & dayofweek(arguments.leave) & "
        ORDER BY a.name
      ";
      result = application.couchbase.n1qlQuery(
        statement=queryPrep
      );
      if (result.success) {
        for (var flight in result.results) {
          flight['flighttime'] = flightTime;
          flight['price'] = round( price * ( ( 100 - ( int( rand("SHA1PRNG") * ( 20 ) + 1 ) ) ) / 100 ) );
        }
        ret = result.results;
      }
      return ret;
    }
  }

  /**
  * A ColdFusion port of the NodeJS haversine module https://github.com/njj/haversine/
  * @start A structure of the starting latitude / longitude
  * @end A structure of the ending latitude / longitude
  * @options A structure of Options
  *          @unit Can be "km" or "mile"
  *          @threshold Used to determine if the calculated value is less than the threshold
  */
  public numeric function haversine( required struct start, required struct end, struct options={} ) {
    var km = 6371;
    var mile = 3960;
    arguments['options']['unit'] = structKeyExists(arguments.options, "unit") ? arguments.options.unit : "km";
    var R = arguments.options.unit == "mile" ? mile : km;
    var dLat = ( arguments.end.latitude - arguments.start.latitude ) * ( pi() / 100 );
    var dLon = ( arguments.end.longitude - arguments.start.longitude ) * ( pi() / 100 );
    var lat1 = ( arguments.start.latitude ) * ( pi() / 100 );
    var lat2 = ( arguments.end.latitude ) * ( pi() / 100 );
    var a = sin( dLat / 2 ) * sin( dLat / 2 ) +
            sin( dLon / 2 ) * sin( dLon / 2 ) * cos( lat1 ) * cos( lat2 );
    var c = 2 * createObject( "java", "java.lang.Math" ).atan2( sqr( a ), sqr( 1 - a ) );
    if (structKeyExists( arguments.options, "threshold" ) && arguments.options.threshold) {
      return options.threshold > (R * c)
    }
    else {
      return R * c
    }
  }

}
