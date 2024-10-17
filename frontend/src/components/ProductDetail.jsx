import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useParams } from 'react-router-dom';

function ProductDetail() {
  const [product, setProduct] = useState(null);
  const { id } = useParams();

  useEffect(() => {
    const fetchProduct = async () => {
      console.log('Fetching product:', id);
      try {
        const response = await axios.get(`http://localhost:8080/juiceBar/getProductbyID?Product_id=${id}`);
        setProduct(response.data);
      } catch (error) {
      console.error('Error fetching product:', error);
      }
    };

    fetchProduct();
  }, [id]);

  if (!product) return <div>Loading...</div>;

  return (
    <div className="product-detail">
      <h2>{product.product_name}</h2>
      <p>Price: ${product.unit_price}</p>
      <p>Available: {product.availability ? 'Yes' : 'No'}</p>
      <button>Add to Cart</button>
    </div>
  );
}

export default ProductDetail;