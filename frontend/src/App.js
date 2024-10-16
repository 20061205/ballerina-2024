import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Navbar from './components/Navbar';
import Home from './pages/Home';
import Menu from './pages/Menu';
import Order from './pages/Order';
import Cart from './pages/Cart';
import './App.css';

function App() {
  return (
    <Router>
      <div className="App">
        <Navbar />
        <main className="content">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/menu" element={<Menu />} />
            <Route path="/order" element={<Order />} />
            <Route path="/cart" element={<Cart />} />
          </Routes>
        </main>
        <footer className="footer">
          <p>&copy; 2024 Juice & Fruit Salad Bar. All rights reserved.</p>
        </footer>
      </div>
    </Router>
  );
}

export default App;