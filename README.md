# CFCouchbase Travel Sample

This is a ColdFusion port of the Couchbase NodeJS Travel Sample Application [https://github.com/couchbaselabs/try-cb-nodejs]()

###Requirements

1. [CommandBox](https://www.ortussolutions.com/products/commandbox)
2. [Couchbase Server 4.0+](http://www.couchbase.com/nosql-databases/downloads)
3. The Couchbase `travel-sample` bucket.  This can either be installed at the time you install Couchbase Server or afterwards through the Administrator.  See the following for more details  [http://developer.couchbase.com/documentation/server/4.1/settings/install-sample-buckets.html]()

### Setup

1\. Clone the Repository

```
git clone git@github.com:coldbox-samples/cfcouchbase-travel.git
```

2\. Change directories and Install dependencies

```
cd cfcouchbase-travel
box install
```

3\. Make sure that your Couchbase Server is running

4\. Start the Lucee Server

```
box server start
```

### How to Use

1. Create a New User
2. Search for flights using the code `LAX` as "From Airport" and `SFO` as the "To Airport"
3. Enter in any future dates for the departure and return
4. Click the "Find Flights" button
5. Click the "Choose" button next to the departure and returning flights
6. Click the "Cart" icon at the top of the page
7. Click the "Book Flights" button to purchase the flights
8. Click the User Account Icon to view previously booked flights
