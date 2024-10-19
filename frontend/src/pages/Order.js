import React, { useState, useEffect } from 'react';
import '../App.css'

function Order() {
  const [products, setProducts] = useState([]);
  const [order, setOrder] = useState({
    user_id: '1', // You might want to get this from user authentication
    products: []
  });
  const [customerOrders, setCustomerOrders] = useState([]);

  useEffect(() => {
    // Fetch customer orders from your Ballerina backend
    fetch(`http://localhost:8080/juiceBar/getOrdersByCustomerID?Customer_id=${order.user_id}`)
      .then(response => response.json())
      .then(data => {
        if (Array.isArray(data)) {
          // Group products by order_id
          const orders = data.reduce((acc, item) => {
            const order = acc.find(o => o.order_id === item.order_id);
            if (order) {
              order.products.push(item);
            } else {
              acc.push({ ...item, products: [item] });
            }
            return acc;
          }, []);
          setCustomerOrders(orders);
        } else {
          setCustomerOrders([]);
        }
      })
      .catch(error => {
        console.error('Error fetching customer orders:', error);
        setCustomerOrders([]);
      });
  }, [order.user_id]);

  const handleRemoveFromOrder = (productId) => {
    setOrder(prevOrder => ({
      ...prevOrder,
      products: prevOrder.products.filter(item => item.product_ID !== productId)
    }));
  };

  const handleExtendOrder = (orderId) => {
    // Logic to extend the order within the first 30 minutes
    console.log(`Extend order with ID: ${orderId}`);
  };

  return (
    <div className="order-container">
      <div className="order-summary">
        <h3>Order Summary</h3>
        {order.products.map(item => (
          <div key={item.product_ID} className="order-item">
            <span>{item.product_name} - ${item.unit_price}</span>
            <button onClick={() => handleRemoveFromOrder(item.product_ID)}>Remove</button>
          </div>
        ))}
      </div>
      <div className="customer-orders">
        <h3>Your Orders</h3>
        {customerOrders.length > 0 ? (
          customerOrders.map(order => (
            <div key={order.order_id} className="customer-order">
             
              <p>Date: {order.ordered_date}</p>
              <div className="order-items">
                {order.products.map(product => (
                  <div key={product.product_ID} className="order-item">
                    <img src={product.image} alt={product.product_name} className="product-image" />
                    <span>{product.product_name} - ${product.unit_price}</span>
                  </div>
                ))}
              </div>
              <button onClick={() => handleExtendOrder(order.order_id)}>Extend Order</button>
            </div>
          ))
        ) : (
          <p>No orders found.</p>
        )}
      </div>
    </div>
  );
}

export default Order;