# Nature's Nectar Juice Shop Project

This project is a full-stack application for a juice shop, consisting of a backend built with Ballerina and a frontend built with React.

## Overview of the problem and Introduction to the project
For our project, we have decided to build a website for a juice bar. The purpose of the project was to enhance the efficiency of the juice bar's ordering and management process, ultimately saving time for the shop's customers. Through our website, we offer solutions to the problem of customers having to wait after placing their order. Also, our website makes work easier for the staff by reducing long queues and the rush during peak business hours.

## Project Structure

## Functionalities

### Backend Functionalities
1. **Product Management**:
   - **Get Product by ID**: Retrieve product details by product ID.
   - **Add Product**: Add new products to the inventory.
   - **Update Product**: Update existing product details.
   - **Delete Product**: Remove products from the inventory.

2. **Order Management**:
   - **Create Order**: Place a new order.
   - **Get Orders by Customer ID**: Retrieve all orders placed by a specific customer.
   - **Update Order Status**: Change the status of an order (e.g., from "Processing" to "Shipped").
   - **Extend Order**: Extend the delivery time of an order.
   - **Delete Order**: Cancel an order.

3. **User Management**:
   - **User Signup**: Register new users (customers and admins).
   - **User Login**: Authenticate users and provide access based on user roles.

### Frontend Functionalities
1. **User Interface**:
   - **Product Listing**: Display a list of available products.
   - **Product Details**: Show detailed information about a selected product.
   - **Order Summary**: Display a summary of the user's current order.
   - **Order History**: Show a list of past orders placed by the user.

2. **User Actions**:
   - **Place Order**: Finalize and place an order.
   - **Extend Order**: Extend the delivery time of an order.
   - **Cancel Order**: Cancel an existing order.

3. **Admin Actions**:
   - **Manage Orders**: View and update the status of orders.
  

## Backend

The backend is built using Ballerina and handles the business logic and database interactions.

### Setup

1. **Install Ballerina**: Follow the instructions on the [Ballerina website](https://ballerina.io/downloads/) to install Ballerina.
2. **Database Setup**: Import the `juice_shop.sql` file into your MySQL database.
3. **Configuration**: Update the `Config.toml` file with your database connection details.
4. **Run the Backend**:
    ```sh
    cd backend
    ballerina run main.bal
    ```

### Endpoints

- **Get Product by ID**: `GET /juiceBar/getProductbyID?Product_id={id}`
- **Delete Order**: `POST /juiceBar/deleteOrder?order_id={id}`
- **Extend Order**: `POST /juiceBar/extendOrder`

## Frontend

The frontend is built using React and provides the user interface for the juice shop.

### Setup

1. **Install Node.js**: Follow the instructions on the [Node.js website](https://nodejs.org/) to install Node.js.
2. **Install Dependencies**:
    ```sh
    cd frontend
    npm install
    ```
3. **Run the Frontend**:
    ```sh
    npm start
    ```

### Structure

- **`src/`**: Contains the source code for the frontend.
- **`public/`**: Contains the public assets like `index.html` and `manifest.json`.

## Development

### Backend

- **Build**: 
    ```sh
    cd backend
    ballerina build main.bal
    ```
- **Run Tests**:
    ```sh
    ballerina test
    ```

### Frontend

- **Run Tests**:
    ```sh
    npm test
    ```
- **Build for Production**:
    ```sh
    npm run build
    ```

