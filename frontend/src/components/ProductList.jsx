import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import '../App.css';

function ProductList() {
  const [products, setProducts] = useState([]);

  useEffect(() => {
    axios.get('http://localhost:8080/juiceBar/getProducts')
      .then(response => {
        setProducts(response.data);
      })
      .catch(error => {
        console.error('Error fetching products:', error);
      });
  }, []);

  console.log(products);

  const navigate = useNavigate();

  const handleViewItem = (item) => {
    console.log('View item:', item);
    navigate(`/product/${item.product_ID}`);
  };

  return (
    <div className="product-list">
      <h2>Our Juices</h2>
  
      <div className="featured-grid">
        {products.map((item, index) => (
          <div className="featured-item" key={index}>
            <img src={item.image} alt={item.altText || item.product_name} />
            <h3>{item.product_name}</h3>
            <p>{item.availability ? 'In Stock' : 'Out of Stock'}</p>
            <p>Price: ${item.unit_price}</p>
            <button className="btn btn-primary" onClick={() => handleViewItem(item)}>View item</button>
          </div>
        ))}
      </div>
    </div>
  );
  
}

export default ProductList;