import ballerina/http;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/io;

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

    resource function get getProductbyID(http:Caller caller, http:Request req) returns error? {
        // Extract the product ID from the query parameters
        var productIdParam = req.getQueryParamValue("Product_id");
        io:println(productIdParam);
        if productIdParam is string {
            int productId = check 'int:fromString(productIdParam);

            // Execute the SQL query with the provided product ID
            stream<record {|anydata...;|}, sql:Error?> resultStream = pool->query(`SELECT * FROM products WHERE Product_id = ${productId}`);
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
        } else {
            // Send an error response if the product ID is not provided
            check caller->respond({ "error": "Product_id query parameter is missing or invalid" });
        }
    }
}