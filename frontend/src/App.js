// src/App.js

import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
//import Navbar from './components/Navbar';
import ProductList from './components/ProductList';
import ProductDetail from './components/ProductDetail';
// import Cart from './components/Cart';
// import Checkout from './components/Checkout';

function App() {
  return (
    <Router>
      <div className="App">
        {/* <Navbar /> */}
        <Routes>
          <Route path="/" element={<ProductList />} />
          <Route path="/product/:id" element={<ProductDetail />} />
         {/* // <Route path="/cart" element={<Cart />} />
         // <Route path="/checkout" element={<Checkout />} /> */}
        </Routes>
      </div>
    </Router>
  );
}

export default App;
