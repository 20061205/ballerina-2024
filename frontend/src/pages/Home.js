import React from 'react';
import { Link } from 'react-router-dom';
import ProductList from '../components/ProductList';

function Home() {


return (
    <div className="home">
        <div className="welcome-message">
            <h2>Hello, {localStorage.getItem('firstname')}!</h2>
        </div>
        <h1>Welcome to our Juice Bar</h1>
        <p>Discover our fresh and delicious offerings!</p>
        <div className="cta-buttons">
           
            <Link to="/makeorder/:id" className="cta-button">Order Now</Link>
        </div>
        <div className="featured-items">
            
            <ProductList />
           
        </div>
        
    </div>
);
}

export default Home;