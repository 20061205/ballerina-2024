import ballerina/http;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

type databaseConfig record {|
    string host;
    string user;
    string password;
    string database;
    int port;
|};

configurable databaseConfig connection = ?;

mysql:Client pool = check new (host = connection.host,
                               user = connection.user,
                               password = connection.password,
                               database = connection.database,
                               port = connection.port);

// Core configure
@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"],
        allowHeaders: ["Content-Type"],
        allowMethods: ["GET", "POST", "OPTIONS"]
    }
}

// Define the service
service /juiceBar on new http:Listener(8080) {

    // Resource function to handle POST requests to the /getProducts endpoint
    resource function get getProducts(http:Caller caller, http:Request req) returns error? {
        

        // Execute the SQL query
        stream<record {|anydata...;|}, sql:Error?> resultStream = pool->query(`SELECT * FROM products`);
        json[] resultJson = [];

        // Process the result stream and build the JSON response
        check resultStream.forEach(function(record {|anydata...;|} row) {
            map<json> rowJson = {};
            foreach var [key, value] in row.entries() {
                rowJson[key] = <json>value;
            }
            resultJson.push(rowJson);
        });

        // Send the result back to the client
        check caller->respond(resultJson);
    }
}