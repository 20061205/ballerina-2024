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
    string order_time;
    Product[] products; 
|};

type Product record {| 
    int product_ID; 
    string product_name; 
    float unit_price; 
    int quantity;
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
            io:println(resultJson);
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
            stream<record {|anydata...;|}, sql:Error?> resultStream = pool->query(`SELECT * FROM customer_orders left outer join order_items using (order_id) left outer join products on products.product_ID=order_items.product_id left outer join order_status using (status_id) WHERE customer_orders.user_id =${customerId}`);
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

  
     resource function post submitItem(http:Caller caller, http:Request req) returns error? {
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
        io:println(payload);

        int orderId = check 'int:fromString((check payload.order_id).toString());
        int productId = check 'int:fromString((check payload.productId).toString());
        int quantity = check 'int:fromString((check payload.quantity).toString());


        // Insert into order_item table
        // sql:ParameterizedQuery itemQuery = `INSERT INTO order_item (order_id, product_id, quantity) 
        //                                     VALUES (?, ?, ?)`;
        // var itemResult = pool->execute( `INSERT INTO order_item (order_id, product_id, quantity) 
        //                                                 VALUES (${orderId}, ${productId},${quantity});`);
        var itemResult = pool->execute( ` INSERT INTO order_items (order_id, product_id, quantity) 
                                                        VALUES (${orderId}, ${productId},${quantity});`);

        if (itemResult is sql:ExecutionResult) {
            // Send a success response back to the client
            http:Response response = new;
            response.statusCode = 201;
            response.reasonPhrase = "Created";
            response.setPayload({ "message": "Order item inserted successfully" });
            check caller->respond(response);
        } else {
            // Send an error response if the insertion fails
            http:Response response = new;
            response.statusCode = 500;
            response.reasonPhrase = "Internal Server Error";
            response.setPayload({ "error": "Failed to insert order item" });
            check caller->respond(response);
        }
    }

    // resource function to add a oredr to the database

     resource function post submitOrder(http:Caller caller, http:Request req) returns error? {
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
        io:println(payload);

        int userId = check 'int:fromString((check payload.user_id).toString());
        int statusId = check 'int:fromString((check payload.status_id).toString());
        string orderedDate = (check payload.ordered_date).toString();
        string orderedTime = (check payload.ordered_time).toString();
        string dilivaryTime = (check payload.dilivary_time).toString();

        // Call the SQL function to insert the order and get the order ID
        sql:ParameterizedQuery query = `SELECT InsertCustomerOrderAndReturnID(${userId}, ${statusId}, ${orderedDate}, ${orderedTime}, ${dilivaryTime}) AS order_id`;
        stream<record {| int order_id; |}, sql:Error?> resultStream = pool->query(query);
        var result = check resultStream.next();
        if result is record {| record {| int order_id; |} value; |} {
            int orderId = result.value.order_id;
            io:println("Order ID: ", orderId);

            // Send the order ID back to the client
            http:Response response = new;
            response.statusCode = 201;
            response.reasonPhrase = "Created";
            response.setPayload({ "order_id": orderId });
            check caller->respond(response);
        } else {
            // Send an error response if the function call fails
            http:Response response = new;
            response.statusCode = 500;
            response.reasonPhrase = "Internal Server Error";
            response.setPayload({ "error": "Failed to insert order" });
            check caller->respond(response);
        }
    }

     resource function post deleteOrder(http:Caller caller, http:Request req) returns error? {
        var orderId =  req.getQueryParamValue("order_id");
        io:println(orderId);
       
        var result = pool->execute( `DELETE FROM customer_orders WHERE order_id = ${orderId}`);

        if (result is sql:ExecutionResult) {
            // Send a success response back to the client
            http:Response response = new;
            response.statusCode = 200;
            response.reasonPhrase = "OK";
            response.setPayload({ "message": "Order deleted successfully" });
            check caller->respond(response);
        } else {
            // Send an error response if the deletion fails
            http:Response response = new;
            response.statusCode = 500;
            response.reasonPhrase = "Internal Server Error";
            response.setPayload({ "error": "Failed to delete order" });
            check caller->respond(response);
        }
    }

       resource function post extendOrder(http:Caller caller, http:Request req) returns error? {
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
        io:println(payload);
    
        int orderId = check 'int:fromString((check payload.order_id).toString());
        // Assuming the new delivery time is calculated and passed in the payload
        string newDilivaryTime = (check payload.new_dilivary_time).toString();
        io:println("time", newDilivaryTime);
    
       // sql:ParameterizedQuery query = `UPDATE customer_orders SET dilivary_time = ? WHERE order_id = ?`;
        var result = pool->execute(`UPDATE customer_orders SET dilivary_time = ${newDilivaryTime} WHERE order_id = ${orderId}`);
    
        if (result is sql:ExecutionResult) {
            // Send a success response back to the client
            http:Response response = new;
            response.statusCode = 200;
            response.reasonPhrase = "OK";
            response.setPayload({ "new_dilivary_time": newDilivaryTime });
            check caller->respond(response);
        } else {
            // Send an error response if the update fails
            http:Response response = new;
            response.statusCode = 500;
            response.reasonPhrase = "Internal Server Error";
            response.setPayload({ "error": "Failed to extend order" });
            check caller->respond(response);
        }
    }

          resource function get getAllOrders(http:Caller caller, http:Request req) returns error? {
        stream<record {| 
            int order_id; 
            int user_id; 
            string ordered_date; 
            string ordered_time; 
            string dilivary_time; 
            int status_id; 
            string status; 
            decimal? total_price; 
            string description;
        |}, sql:Error?> resultStream = pool->query(`SELECT * FROM customer_orders LEFT OUTER JOIN Order_status USING (status_id)`);
    
        json[] resultJson = [];
        check resultStream.forEach(function(record {| anydata...; |} row) {
            map<json> rowJson = {};
            foreach var [key, value] in row.entries() {
                rowJson[key] = <json>value;
            }
            resultJson.push(rowJson);
        });
    
        check caller->respond(resultJson);
    }

     resource function get getStatuses(http:Caller caller, http:Request req) returns error? {
        sql:ParameterizedQuery query = `SELECT * FROM order_status`;
        stream<record {| int status_id; string status; string description; |}, sql:Error?> resultStream = pool->query(query);

        json[] resultJson = [];
        check resultStream.forEach(function(record {| anydata...; |} row) {
            map<json> rowJson = {};
            foreach var [key, value] in row.entries() {
                rowJson[key] = <json>value;
            }
            resultJson.push(rowJson);
        });

        check caller->respond(resultJson);
    }

     resource function post updateOrderStatus(http:Caller caller, http:Request req) returns error? {
        json payload;
        var jsonResult = req.getJsonPayload();
        io:println("Hi",jsonResult);
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
        io:println(payload);

        int orderId = check 'int:fromString((check payload.order_id).toString());
        int statusId = check 'int:fromString((check payload.status_id).toString());

       io:println(orderId, statusId);
        var result = pool->execute(`UPDATE customer_orders SET status_id = ${statusId} WHERE order_id = ${orderId}` );
         if (result is sql:ExecutionResult) {
            // Send a success response back to the client
            http:Response response = new;
            response.statusCode = 200;
            response.reasonPhrase = "OK";
            response.setPayload({ "message": "Order status updated successfully" });
            check caller->respond(response);
        } else {
            // Send an error response if the update fails
            http:Response response = new;
            response.statusCode = 500;
            response.reasonPhrase = "Internal Server Error";
            response.setPayload({ "error": "Failed to update order status" });
            check caller->respond(response);
        }
    }
    
}