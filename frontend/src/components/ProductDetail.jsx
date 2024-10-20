import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useParams, useNavigate } from 'react-router-dom';

function ProductDetail() {
  const [product, setProduct] = useState(null);
  const { id } = useParams();
  const navigate = useNavigate();

  useEffect(() => {
    const fetchProduct = async () => {
      console.log('Fetching product:', id);
      try {
        const response = await axios.get(`http://localhost:8080/juiceBar/getProductbyID?Product_id=${id}`);
        setProduct(response.data[0]);
      } catch (error) {
        console.error('Error fetching product:', error);
      }
    };

    fetchProduct();
  }, [id]);

  if (!product) return <div>Loading...</div>;
  console.log('Product:', product);

  const handleOrderNow = () => {
    navigate(`/makeorder/${id}`);
  };

  return (
    <div className="product-detail">
      <h1>Product Detail</h1>
      <h2>{product.product_name}</h2>
      <img src={product.image} alt={product.altText} style={{ width: '300px', height: '300px' }} />
      <p>Price: ${product.unit_price}</p>
      <p>Available: {product.availability ? 'Yes' : 'No'}</p>
      <button onClick={handleOrderNow}>Order now</button>
    </div>
  );
}

export default ProductDetail;