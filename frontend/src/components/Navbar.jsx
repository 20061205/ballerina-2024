import React, { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import '../App.css'; // Import CSS for styling

function Navbar() {
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const navigate = useNavigate();
  
  useEffect(() => {
    const userId = localStorage.getItem('user_id');
    if (userId) {
      setIsLoggedIn(true);
    }

    // Listen for the custom event 'userLoggedIn'
    const handleLoginEvent = (event) => {
      setIsLoggedIn(true);
    };

    window.addEventListener('userLoggedIn', handleLoginEvent);

    // Cleanup event listener on component unmount
    return () => {
      window.removeEventListener('userLoggedIn', handleLoginEvent);
    };
  }, []);

  

  const handleLogout = () => {
    localStorage.removeItem('user_id');
    localStorage.removeItem('firstname');
    setIsLoggedIn(false);
    navigate('/');
  };

  return (
    <nav className="navbar">
      <div className="navbar-brand">Juice & Fruit Salad Bar</div>
      <ul className="navbar-links">
        <li><Link to="/">Home</Link></li>
        <li><Link to="/menu">Menu</Link></li>
        <li><Link to="/order">Order</Link></li>
     
        {isLoggedIn ? (
          <>
            <li><button onClick={handleLogout} className="logout-button">Log Out</button></li>
            <li>
              <Link to="/profile">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
  <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0"/>
  <path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8m8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1"/>
</svg>
              </Link>
            </li>
          </>
        ) : (
          <>
            <li><Link to="/signin">Sign In</Link></li>
            <li><Link to="/signup">Register</Link></li>
          </>
        )}
      </ul>
    </nav>
  );
}

export default Navbar;