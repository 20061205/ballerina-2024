import React from 'react';
import { Link } from 'react-router-dom';

function Navbar() {
  return (
    <nav className="navbar">
      <div className="navbar-brand">Juice & Fruit Salad Bar</div>
      <ul className="navbar-links">
        <li><Link to="/">Home</Link></li>
        <li><Link to="/menu">Menu</Link></li>
        <li><Link to="/order">Order</Link></li>
        <li><Link to="/cart">Cart</Link></li>
        <li><Link to="/signin">Sign In</Link></li>
        <li><Link to="/signup">Register</Link></li>
      </ul>
    </nav>
  );
}

export default Navbar;