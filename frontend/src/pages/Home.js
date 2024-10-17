import React from 'react';
import { Link } from 'react-router-dom';
import ProductList from '../components/ProductList';

function Home() {
const featuredItems = [
    {
        imgSrc: "https://cooktoria.com/wp-content/uploads/2022/11/Tropical-Smoothie-SQ-1.jpg",
        altText: "Tropical Smoothie",
        title: "Tropical Smoothie",
        description: "A refreshing blend of mango, pineapple, and banana."
    },
    {
        imgSrc: "https://via.placeholder.com/200",
        altText: "Berry Blast Bowl",
        title: "Berry Blast Bowl",
        description: "Acai bowl topped with mixed berries and granola."
    },
    {
        imgSrc: "https://via.placeholder.com/200",
        altText: "Green Goddess Juice",
        title: "Green Goddess Juice",
        description: "A nutritious mix of kale, apple, cucumber, and lemon."
    }
];

return (
    <div className="home">
        <h1>Welcome to our Juice & Fruit Salad Bar</h1>
        <p>Discover our fresh and delicious offerings!</p>
        <div className="cta-buttons">
            <Link to="/menu" className="cta-button">View Menu</Link>
            <Link to="/order" className="cta-button">Order Now</Link>
        </div>
        <div className="featured-items">
            <h2>Featured Items</h2>
            <ProductList />
            <div className="featured-grid">
                {featuredItems.map((item, index) => (
                    <div className="featured-item" key={index}>
                        <img src={item.imgSrc} alt={item.altText} style={{ width: '200px', height: '200px' }} />
                        <h3>{item.title}</h3>
                        <p>{item.description}</p>
                    </div>
                ))}
            </div>
        </div>
    </div>
);
}

export default Home;