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

type User record {| 
    string first_name; 
    string last_name; 
    string username; 
    string password; 
    string email; 
    string user_type; 
    string phone_number; 
|};

type Order record {| 
    int order_id; 
    string order_date; 
    int user_id; 
    Product[] products; 
|};

type Product record {| 
    int product_ID; 
    string product_name; 
    float unit_price; 
|};

type LUser record {| 
    string username; 
    string password; 
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

    resource function get getOrdersByCustomerID(http:Caller caller, http:Request req) returns error? {
        // Extract the customer ID from the query parameters
        var customerIdParam = req.getQueryParamValue("Customer_id");
        io:println(customerIdParam);
        if customerIdParam is string {
            int customerId = check 'int:fromString(customerIdParam);

            // Execute the SQL query with the provided customer ID
            stream<record {|anydata...;|}, sql:Error?> resultStream = pool->query(`SELECT * FROM customer_orders left outer join order_items using (order_id) left outer join products on products.product_ID=order_items.product_id  WHERE customer_orders.user_id =${customerId}`);
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
            // Send an error response if the customer ID is not provided
            check caller->respond({ "error": "Customer_id query parameter is missing or invalid" });
        }
    }

    resource function post registerUser(http:Caller caller, http:Request req) returns error? {
        json payload;
        var jsonResult = req.getJsonPayload();
        if (jsonResult is json) {
            payload = jsonResult;
        } else {
            http:Response response = new;
            response.statusCode = 400;
            response.reasonPhrase = "Bad Request";
            response.setPayload({ "error": "Invalid JSON payload" });
            check caller->respond(response);
            return;
        }

        
            string first_name= (check payload.first_name).toString();
            string last_name= (check payload.last_name).toString();
            string username = (check payload.username).toString();
            string password = (check payload.password).toString();
            string email = (check payload.email).toString();
            string user_type =(check payload.user_type).toString();
            string phone_number = (check payload.phone_number).toString();

        

    
        // Construct the SQL query with actual values
        // sql:ParameterizedQuery query = `INSERT INTO users (first_name, last_name, username, password, email, user_type, phone_number) 
        //                                 VALUES ('${newUser.first_name}', '${newUser.last_name}', '${newUser.username}', '${newUser.password}', '${newUser.email}', '${newUser.user_type}', '${newUser.phone_number}')`;
        var result = pool->execute(`INSERT INTO users (first_name, last_name, username, password, email, user_type, phone_number) 
                                        VALUES (${first_name}, ${last_name}, ${username}, ${password}, ${email}, ${user_type}, ${phone_number})`);
       
//   var result = pool->execute(`INSERT INTO users (first_name, last_name, username, password, email, user_type, phone_number) values
// ('John', 'Doe', 'johnafasdsffdoe', 'password123', 'john.doe@example.com', 'customer', '1234567890');`);
     
        if (result is sql:ExecutionResult) {
            // Send a success response back to the client
            http:Response response = new;
            response.statusCode = 201;
            response.reasonPhrase = "Created";
            response.setPayload({ "message": "User registered successfully" });
            check caller->respond(response);
        } 
    }

     resource function post checkUser(http:Caller caller, http:Request req) returns error? {
        json payload;
        var jsonResult = req.getJsonPayload();
        if (jsonResult is json) {
            payload = jsonResult;
        } else {
            http:Response response = new;
            response.statusCode = 400;
            response.reasonPhrase = "Bad Request";
            response.setPayload({ "error": "Invalid JSON payload" });
            check caller->respond(response);
            return;
        }

        LUser user = check payload.cloneWithType(LUser);
        io:print("user", user);

        // Execute the SQL query to check if the user exists
        // sql:ParameterizedQuery query = `SELECT * FROM users WHERE username = ? AND password = ?`;
        stream<record {|anydata...;|}, sql:Error?> resultStream = pool->query(`SELECT * FROM users WHERE username = ${user.username} AND password = ${user.password}` );
        json[] resultJson = [];
        io:print("resultStream", resultStream);

        // Process the result stream and build the JSON response
        check resultStream.forEach(function(record {|anydata...;|} row) {
            map<json> rowJson = {};
            foreach var [key, value] in row.entries() {
                rowJson[key] = <json>value;
            }
             resultJson.push(rowJson);
        });

        if (resultJson.length() > 0) {
            // User found, send user details
            check caller->respond(resultJson[0]);
        } else {
            // User not found, send error message
            http:Response response = new;
            response.statusCode = 401;
            response.reasonPhrase = "Unauthorized";
            response.setPayload({ "error": "Invalid login credentials" });
            check caller->respond(response);
        }
    }

     resource function get getUserDetails(http:Caller caller, http:Request req) returns error? {
        var userIdParam = req.getQueryParamValue("user_id");
        io:print("\nuser   id",userIdParam);
        if userIdParam is string {
            int userId = check 'int:fromString(userIdParam);

           io:print("\nuser id",userId);
            stream<record {|anydata...;|}, sql:Error?> resultStream = pool->query(`SELECT * FROM users WHERE user_ID = ${userId}`);
            json[] resultJson = [];

            check resultStream.forEach(function(record {|anydata...;|} row) {
                map<json> rowJson = {};
                foreach var [key, value] in row.entries() {
                    rowJson[key] = <json>value;
                }
                resultJson.push(rowJson);
            });

            if (resultJson.length() > 0) {
                check caller->respond(resultJson[0]);
            } else {
                check caller->respond({ "error": "User not found" });
            }
        } else {
            check caller->respond({ "error": "user_id query parameter is missing or invalid" });
        }
    }

    
}