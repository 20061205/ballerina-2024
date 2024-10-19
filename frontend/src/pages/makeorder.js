// import React, { useState, useEffect } from 'react';
// import { useParams, useNavigate } from 'react-router-dom';
// import axios from 'axios';

// function MakeOrder() {
//   const { id } = useParams();
//   const [date, setDate] = useState('');
//   const [time, setTime] = useState('');
//   const [products, setProducts] = useState([]);
//   const [selectedProducts, setSelectedProducts] = useState([]);
//   const [totalPrice, setTotalPrice] = useState(0);
//   const navigate = useNavigate();

//   useEffect(() => {
//     const fetchProducts = async () => {
//       try {
//         const response = await axios.get('http://localhost:8080/juiceBar/getProducts');
//         setProducts(response.data);
//       } catch (error) {
//         console.error('Error fetching products:', error);
//       }
//     };

//     fetchProducts();
//   }, []);

//   const handleProductSelect = (product) => {
//     setSelectedProducts((prevSelectedProducts) => {
//       const existingProduct = prevSelectedProducts.find((p) => p.product_ID === product.product_ID);
//       if (existingProduct) {
//         return prevSelectedProducts.filter((p) => p.product_ID !== product.product_ID);
//       } else {
//         return [...prevSelectedProducts, { ...product, quantity: 1 }];
//       }
//     });
//   };

//   const handleQuantityChange = (productId, quantity) => {
//     setSelectedProducts((prevSelectedProducts) =>
//       prevSelectedProducts.map((product) =>
//         product.product_ID === productId ? { ...product, quantity: parseInt(quantity) } : product
//       )
//     );
//   };

//   useEffect(() => {
//     const calculateTotalPrice = () => {
//       const total = selectedProducts.reduce((sum, product) => sum + product.unit_price * product.quantity, 0);
//       setTotalPrice(total);
//     };

//     calculateTotalPrice();
//   }, [selectedProducts]);

//   const handleSubmit = async (e) => {
//     e.preventDefault();
//     const userId = localStorage.getItem('user_id');
//     const orderDetails = {
//       userId: userId,
//       date: date,
//       time: time,
//       products: selectedProducts.map((product) => ({
//         productId: product.product_ID,
//         quantity: product.quantity,
//       })),
//     };
// console.log(orderDetails);
//     try {
//       const response = await axios.post('http://localhost:8080/juiceBar/submitOrder', orderDetails);
//       if (response.status === 201) {
//         console.log('Order submitted:', response.data);
//         navigate('/order-confirmation'); // Redirect to order confirmation page
//       } else {
//         console.error('Error submitting order:', response.data);
//       }
//     } catch (error) {
//       console.error('Error submitting order:', error);
//     }
//   };

//   return (
//     <div className="make-order">
//       <h1>Make Order</h1>
//       <form onSubmit={handleSubmit}>
//         <div className="form-group">
//           <label htmlFor="date">Select Date:</label>
//           <input
//             type="date"
//             id="date"
//             name="date"
//             value={date}
//             onChange={(e) => setDate(e.target.value)}
//             required
//           />
//         </div>
//         <div className="form-group">
//           <label htmlFor="time">Select Time:</label>
//           <input
//             type="time"
//             id="time"
//             name="time"
//             value={time}
//             onChange={(e) => setTime(e.target.value)}
//             required
//           />
//         </div>
//         <div className="form-group">
//           <label>Select Products:</label>
//           {products.map((product) => (
//             <div key={product.product_ID}>
//               <input
//                 type="checkbox"
//                 id={`product-${product.product_ID}`}
//                 name="products"
//                 value={product.product_ID}
//                 onChange={() => handleProductSelect(product)}
//               />
//               <label htmlFor={`product-${product.product_ID}`}>{product.product_name}</label>
//               {selectedProducts.find((p) => p.product_ID === product.product_ID) && (
//                 <input
//                   type="number"
//                   min="1"
//                   value={selectedProducts.find((p) => p.product_ID === product.product_ID).quantity}
//                   onChange={(e) => handleQuantityChange(product.product_ID, e.target.value)}
//                 />
//               )}
//             </div>
//           ))}
//         </div>
//         <div className="form-group">
//           <label>Total Price: ${totalPrice.toFixed(2)}</label>
//         </div>
//         <button type="submit">Submit Order</button>
//       </form>
//     </div>
//   );
// }

// export default MakeOrder;

import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import axios from 'axios';

function MakeOrder() {
  const { id } = useParams();
  const [date, setDate] = useState('');
  const [time, setTime] = useState('');
  const [products, setProducts] = useState([]);
  const [selectedProducts, setSelectedProducts] = useState([]);
  const [totalPrice, setTotalPrice] = useState(0);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchProducts = async () => {
      try {
        const response = await axios.get('http://localhost:8080/juiceBar/getProducts');
        setProducts(response.data);
      } catch (error) {
        console.error('Error fetching products:', error);
      }
    };

    fetchProducts();
  }, []);

  const handleProductSelect = (product) => {
    setSelectedProducts((prevSelectedProducts) => {
      const existingProduct = prevSelectedProducts.find((p) => p.product_ID === product.product_ID);
      if (existingProduct) {
        return prevSelectedProducts.filter((p) => p.product_ID !== product.product_ID);
      } else {
        return [...prevSelectedProducts, { ...product, quantity: 1 }];
      }
    });
  };

  const handleQuantityChange = (productId, quantity) => {
    setSelectedProducts((prevSelectedProducts) =>
      prevSelectedProducts.map((product) =>
        product.product_ID === productId ? { ...product, quantity: parseInt(quantity) } : product
      )
    );
  };

  useEffect(() => {
    const calculateTotalPrice = () => {
      const total = selectedProducts.reduce((sum, product) => sum + product.unit_price * product.quantity, 0);
      setTotalPrice(total);
    };

    calculateTotalPrice();
  }, [selectedProducts]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    const userId = localStorage.getItem('user_id');
    const statusId = 1; // Assuming status_id is 1 for new orders
    const orderDetails = {
      user_id: userId,
      status_id: statusId,
      ordered_date: date,
      ordered_time: time,
      dilivary_time: time
    };

    try {
      // First, submit the order details to get the order_id
      const orderResponse = await axios.post('http://localhost:8080/juiceBar/submitOrder', orderDetails);
      if (orderResponse.status === 201) {
        const orderId = orderResponse.data.order_id;
        console.log('Order ID:', orderId);

        // Then, submit each product in the order
        for (const product of selectedProducts) {
          const itemDetails = {
            order_id: orderId,
            productId: product.product_ID,
            quantity: product.quantity
          };
          console.log(itemDetails);
          const itemResponse = await axios.post('http://localhost:8080/juiceBar/submitItem', itemDetails);
          if (itemResponse.status !== 201) {
            console.error('Error submitting order item:', itemResponse.data);
          }
        }
        console.log('Order submitted successfully');
        navigate('/order'); // Redirect to order confirmation page
      } else {
        console.error('Error submitting order:', orderResponse.data);
      }
    } catch (error) {
      console.error('Error submitting order:', error);
    }
  };

  return (
    <div className="make-order">
      <h1>Make Order</h1>
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="date">Select Date:</label>
          <input
            type="date"
            id="date"
            name="date"
            value={date}
            onChange={(e) => setDate(e.target.value)}
            required
          />
        </div>
        <div className="form-group">
          <label htmlFor="time">Select Time:</label>
          <input
            type="time"
            id="time"
            name="time"
            value={time}
            onChange={(e) => setTime(e.target.value)}
            required
          />
        </div>
        <div className="form-group">
          <label>Select Products:</label>
          {products.map((product) => (
            <div key={product.product_ID}>
              <input
                type="checkbox"
                id={`product-${product.product_ID}`}
                name="products"
                value={product.product_ID}
                onChange={() => handleProductSelect(product)}
              />
              <label htmlFor={`product-${product.product_ID}`}>{product.product_name}</label>
              {selectedProducts.find((p) => p.product_ID === product.product_ID) && (
                <input
                  type="number"
                  min="1"
                  value={selectedProducts.find((p) => p.product_ID === product.product_ID).quantity}
                  onChange={(e) => handleQuantityChange(product.product_ID, e.target.value)}
                />
              )}
            </div>
          ))}
        </div>
        <div className="form-group">
          <label>Total Price: ${totalPrice.toFixed(2)}</label>
        </div>
        <button type="submit">Submit Order</button>
      </form>
    </div>
  );
}

export default MakeOrder;