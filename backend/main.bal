import ballerina/http;
import ballerinax/mysql;
import ballerina/sql;

// Database configuration
// Database configuration
configurable string dbHost = "localhost";  // Use double quotes for string literals
configurable string dbUser = "root";
configurable string dbPassword = "2002";
configurable string dbName = "juice_shop";

// Initialize the MySQL client
mysql:Client dbClient = check new (host=dbHost, user=dbUser, password=dbPassword, database=dbName, port=3306); 
// Data models
type User record {
    int user_ID?;
    string first_name;
    string last_name;
    string username;
    string password;
    string email;
    string user_type;
    string phone_number;
};

type Product record {
    int product_ID?;
    string product_name;
    decimal unit_price;
    boolean availability;
    string image;
};

type OrderStatus record {
    int status_id?;
    string Status;
    string description;
};

type Order record {
    int order_id?;
    int user_id;
    int status_id;
    string ordered_date;
    string ordered_time;
    string expriory_date;
};

type OrderItem record {
    int order_item_id?;
    int order_id;
    int product_id;
    int quantity;
};

// CRUD operations for User
function createUser(User user) returns int|error {
    sql:ParameterizedQuery query = `INSERT INTO user (first_name, last_name, username, password, email, user_type, phone_number)
                                    VALUES (${user.first_name}, ${user.last_name}, ${user.username}, ${user.password}, ${user.email}, ${user.user_type}, ${user.phone_number})`;
    sql:ExecutionResult result = check dbClient->execute(query);
    return <int>result.lastInsertId;
}

function getUserById(int id) returns User|error {
    User user = check dbClient->queryRow(`SELECT * FROM user WHERE user_ID = ${id}`);
    return user;
}

function updateUser(User user) returns boolean|error {
    sql:ExecutionResult result = check dbClient->execute(`
        UPDATE user SET
        first_name = ${user.first_name},
        last_name = ${user.last_name},
        username = ${user.username},
        password = ${user.password},
        email = ${user.email},
        user_type = ${user.user_type},
        phone_number = ${user.phone_number}
        WHERE user_ID = ${user.user_ID}
    `);
    return result.affectedRowCount > 0;
}

function deleteUser(int id) returns boolean|error {
    sql:ExecutionResult result = check dbClient->execute(`DELETE FROM user WHERE user_ID = ${id}`);
    return result.affectedRowCount > 0;
}

// CRUD operations for Product
function createProduct(Product product) returns int|error {
    sql:ExecutionResult result = check dbClient->execute(`
        INSERT INTO products (product_name, unit_price, availability, image)
        VALUES (${product.product_name}, ${product.unit_price}, ${product.availability}, ${product.image})
    `);
    return <int>result.lastInsertId;
}

function getProductById(int id) returns Product|error {
    Product product = check dbClient->queryRow(`SELECT * FROM products WHERE product_ID = ${id}`);
    return product;
}

function updateProduct(Product product) returns boolean|error {
    sql:ExecutionResult result = check dbClient->execute(`
        UPDATE products SET
        product_name = ${product.product_name},
        unit_price = ${product.unit_price},
        availability = ${product.availability},
        image = ${product.image}
        WHERE product_ID = ${product.product_ID}
    `);
    return result.affectedRowCount > 0;
}

function deleteProduct(int id) returns boolean|error {
    sql:ExecutionResult result = check dbClient->execute(`DELETE FROM products WHERE product_ID = ${id}`);
    return result.affectedRowCount > 0;
}

// CRUD operations for Order
function createOrder(Order newOrder) returns int|error {
    sql:ExecutionResult result = check dbClient->execute(`INSERT INTO order (user_id, status_id, ordered_date, ordered_time, expriory_date) VALUES (${newOrder.user_id}, ${newOrder.status_id}, ${newOrder.ordered_date}, ${newOrder.ordered_time}, ${newOrder.expriory_date}) `);
    return <int>result.lastInsertId;
}

function getOrderById(int id) returns Order|error {
    Order newOrder = check dbClient->queryRow(`SELECT * FROM order WHERE order_id = ${id}`);
    return newOrder;
}

function updateOrder(Order updatedOrder) returns boolean|error {
    sql:ExecutionResult result = check dbClient->execute(` UPDATE order SET user_id = ${updatedOrder.user_id},status_id = ${updatedOrder.status_id}, ordered_date = ${updatedOrder.ordered_date},ordered_time = ${updatedOrder.ordered_time}, expriory_date = ${updatedOrder.expriory_date} WHERE order_id = ${updatedOrder.order_id}`);
    return result.affectedRowCount > 0;
}

function deleteOrder(int id) returns boolean|error {
    sql:ExecutionResult result = check dbClient->execute(`DELETE FROM order WHERE order_id = ${id}`);
    return result.affectedRowCount > 0;
}

// HTTP service
service / on new http:Listener(8080) {
    // User endpoints
    resource function post users(@http:Payload User user) returns int|error {
        return createUser(user);
    }

    resource function get users/[int id]() returns User|error {
        return getUserById(id);
    }

    resource function put users(@http:Payload User user) returns boolean|error {
        return updateUser(user);
    }

    resource function delete users/[int id]() returns boolean|error {
        return deleteUser(id);
    }

    // Product endpoints
    resource function post products(@http:Payload Product product) returns int|error {
        return createProduct(product);
    }

    resource function get products/[int id]() returns Product|error {
        return getProductById(id);
    }

    resource function put products(@http:Payload Product product) returns boolean|error {
        return updateProduct(product);
    }

    resource function delete products/[int id]() returns boolean|error {
        return deleteProduct(id);
    }

    // Order endpoints
    resource function post orders(@http:Payload Order newOrder) returns int|error {
        return createOrder(newOrder);
    }
    
    resource function get orders/[int id]() returns Order|error {
        return getOrderById(id);
    }
    
    resource function put orders(@http:Payload Order newOrder) returns boolean|error {
        return updateOrder(newOrder);
    }
    
    resource function delete orders/[int id]() returns boolean|error {
        return deleteOrder(id);
    }

    //check database conectovity
    resource function get testCreate() returns int|error {
        User testUser = {
            first_name: "Test",
            last_name: "User",
            username: "testuser",
            password: "password123",
            email: "test@example.com",
            user_type: "customer",
            phone_number: "1234567890"
        };
        return createUser(testUser);
    }

    resource function get testRead/[int id]() returns User|error {
        return getUserById(id);
    }

    resource function get testUpdate/[int id]() returns boolean|error {
        User updatedUser = {
            user_ID: id,
            first_name: "Updated",
            last_name: "User",
            username: "updateduser",
            password: "newpassword123",
            email: "updated@example.com",
            user_type: "customer",
            phone_number: "0987654321"
        };
        return updateUser(updatedUser);
    }

    resource function get testDelete/[int id]() returns boolean|error {
        return deleteUser(id);
    }
}
