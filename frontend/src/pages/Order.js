import React, { useState, useEffect } from 'react';

function Order() {
  const [products, setProducts] = useState([]);
  const [order, setOrder] = useState({
    user_id: '1', // You might want to get this from user authentication
    products: []
  });

  useEffect(() => {
    // Fetch products from your Ballerina backend
    fetch('http://localhost:8080/products')
      .then(response => response.json())
      .then(data => setProducts(data))
      .catch(error => console.error('Error fetching products:', error));
  }, []);

  const handleAddToOrder = (product) => {
    setOrder(prevOrder => ({
      ...prevOrder,
      products: [...prevOrder.products, { ...product, quantity: 1 }]
    }));
  };

  const handleRemoveFromOrder = (productId) => {
    setOrder(prevOrder => ({
      ...prevOrder,
      products: prevOrder.products.filter(item => item.product_ID !== productId)
    }));
  };

  const handleSubmitOrder = () => {
    // Send order to your Ballerina backend
    fetch('http://localhost:8080/orders', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(order),
    })
    .then(response => response.json())
    .then(data => {
      console.log('Order submitted:', data);
      // Clear the order after submission
      setOrder({ user_id: '1', products: [] });
    })
    .catch(error => console.error('Error submitting order:', error));
  };

  return (
    <div className="order">
      <h2>Place Your Order</h2>
      <div className="product-list">
        {products.map(product => (
          <div key={product.product_ID} className="product-item">
            <h3>{product.product_name}</h3>
            <p>Price: ${product.unit_price}</p>
            <button 
              onClick={() => handleAddToOrder(product)} 
              disabled={!product.availability}
            >
              {product.availability ? 'Add to Order' : 'Out of Stock'}
            </button>
          </div>
        ))}
      </div>
      <div className="order-summary">
        <h3>Order Summary</h3>
        {order.products.map(item => (
          <div key={item.product_ID} className="order-item">
            <span>{item.product_name} - ${item.unit_price}</span>
            <button onClick={() => handleRemoveFromOrder(item.product_ID)}>Remove</button>
          </div>
        ))}
        <button onClick={handleSubmitOrder} disabled={order.products.length === 0}>
          Submit Order
        </button>
      </div>
    </div>
  );
}

export default Order;