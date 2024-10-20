import React, { useState, useEffect } from 'react';
import '../App.css';
import axios from 'axios';

function Order() {
  const [products, setProducts] = useState([]);
  const [order, setOrder] = useState({
    user_id: localStorage.getItem('user_id'), // Get user_id from local storage or default to '1'
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
        console.log('Customer orders:', data);
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

  const handleRemoveOrder = async (orderId) => {
    console.log('Removing order:', orderId);
    try {
      const response = await axios.post(`http://localhost:8080/juiceBar/deleteOrder?order_id=${orderId}`);
      if (response.status === 200) {
        setCustomerOrders(prevOrders => prevOrders.filter(order => order.order_id !== orderId));
        console.log(`Order with ID: ${orderId} removed successfully.`);
      } else {
        console.error('Error removing order:', response.data);
      }
    } catch (error) {
      console.error('Error removing order:', error);
    }
  };

                              const handleExtendOrder = async (orderId) => {
                  try {
                    const orderToExtend = customerOrders.find(order => order.order_id === orderId);
                    if (!orderToExtend) {
                      console.error('Order not found');
                      return;
                    }
                    console.log('Extending order:', orderToExtend);
                
                    // Ensure the delivery time is in a valid format
                    let currentDeliveryTime = orderToExtend.dilivary_time;
                    if (typeof currentDeliveryTime === 'string') {
                      // Construct a valid date-time string
                      const today = new Date().toISOString().split('T')[0]; // Get today's date in YYYY-MM-DD format
                      currentDeliveryTime = new Date(`${today}T${currentDeliveryTime}`);
                    }
                    console.log('Current delivery time:', currentDeliveryTime);
                
                    if (isNaN(currentDeliveryTime.getTime())) {
                      console.error('Invalid delivery time format:', orderToExtend.dilivary_time);
                      return;
                    }
                
                    // Extend the delivery time by 15 minutes
                    const newDeliveryTime = new Date(currentDeliveryTime.getTime() + 15 * 60000); // Add 15 minutes
                    newDeliveryTime.setSeconds(0, 0); // Set seconds and milliseconds to 0
                    const newDeliveryTimeString = newDeliveryTime.toTimeString().split(' ')[0]; // Get only the time part
                    console.log('New delivery time:', newDeliveryTimeString);
                
                    const response = await axios.post('http://localhost:8080/juiceBar/extendOrder', {
                      order_id: orderId,
                      new_dilivary_time: newDeliveryTimeString
                    });
                    console.log('Response:', response);
                    if (response.status === 200) {
                      setCustomerOrders(prevOrders => prevOrders.map(order => 
                        order.order_id === orderId ? { ...order, dilivary_time: newDeliveryTimeString } : order
                      ));
                      console.log(`Order with ID: ${orderId} extended successfully.`);
                    } else {
                      console.error('Error extending order:', response.data);
                    }
                  } catch (error) {
                    console.error('Error extending order:', error);
                  }
                };
    const isButtonDisabled = (orderdate, orderedtime) => {
    const currentTime = new Date();
    let orderDeliveryTime = new Date(orderedtime);
    let orderDeliverydate = new Date(orderdate);
    console.log("orderDeliveryTime",orderDeliveryTime);
    console.log("orderDeliverydate",orderDeliverydate);
    // Construct a valid date-time string
    orderDeliveryTime = new Date(`${orderDeliverydate.toISOString().split('T')[0]}T${orderDeliveryTime.toTimeString().split(' ')[0]}`);
    console.log('Order delivery time:', orderDeliveryTime);
  
    const timeDifference = (currentTime - orderDeliveryTime) / 60000; // Difference in minutes
    console.log('Time difference:', timeDifference);
    return timeDifference > 30;
  };

  return (
    <div className="order-container">
      <div className="order-summary">
        <h3>Order Summary</h3>
        {order.products.map(item => (
          <div key={item.product_ID} className="order-item">
            <img src={item.image} alt={item.product_name} className="product-image" />
            <span>{item.product_name} - ${item.unit_price} x {item.quantity}</span>
            <button onClick={() => handleRemoveFromOrder(item.product_ID)}>Remove</button>
          </div>
        ))}
      </div>
      <div className="customer-orders">
        <h3>Your Orders</h3>
        {customerOrders.length > 0 ? (
          customerOrders.map(order => (
            <div key={order.order_id} className="customer-order">
              <p><strong>Order Date:</strong> {order.ordered_date}</p>
              <p><strong>Delivery Time:</strong> {order.dilivary_time}</p>
              <p><strong>Total Price:</strong> ${order.total_price}</p>
              <p><strong>Order status:</strong> {order.Status}</p>
              <div className="order-items">
                {order.products.map(product => (
                  <div key={product.product_ID} className="order-item">
                    <img src={product.image} alt={product.product_name} className="product-image" />
                    <span>{product.product_name} - ${product.unit_price} x {product.quantity}</span>
                  </div>
                ))}
              </div>
              {!isButtonDisabled(order.ordered_date,order.ordered_time) && (
                <>
                <p>Extend your delivery time by 15 minutes or remove your order.</p>
                  <button onClick={() => handleExtendOrder(order.order_id)}>Extend Order</button>
                  <button onClick={() => handleRemoveOrder(order.order_id)}>Remove Order</button>
                </>
              )}
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