import React, { useState, useEffect } from 'react';

function Menu() {
  const [menuItems, setMenuItems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch('http://localhost:8080/products')
      .then(response => {
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        return response.json();
      })
      .then(data => {
        setMenuItems(data);
        setLoading(false);
      })
      .catch(error => {
        console.error('Error fetching menu items:', error);
        setError('Failed to load menu items. Please try again later.');
        setLoading(false);
      });
  }, []);

  if (loading) {
    return <div className="menu">Loading menu items...</div>;
  }

  if (error) {
    return <div className="menu">{error}</div>;
  }

  return (
    <div className="menu">
      <h2>Our Menu</h2>
      <div className="menu-grid">
        {menuItems.map((item) => (
          <div key={item.product_ID} className="menu-item">
            <img src={item.image || `/api/placeholder/150/150?text=${item.product_name}`} alt={item.product_name} />
            <h3>{item.product_name}</h3>
            <p>${item.unit_price.toFixed(2)}</p>
            <p>{item.availability ? 'In Stock' : 'Out of Stock'}</p>
          </div>
        ))}
      </div>
    </div>
  );
}

export default Menu;