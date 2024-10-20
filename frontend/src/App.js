import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Navbar from './components/Navbar';
import Home from './pages/Home';

import Order from './pages/Order';

import SignIn from './pages/signin';
import SignUp from './pages/signup';
import Profile from './pages/Profile';
import MakeOrder from './pages/makeorder';
import ProductDetail from './components/ProductDetail';
import AdminHome from './pages/adminhome';
import './App.css';

function App() {
  return (
    <Router>
      <div className="App">
        <Navbar />
        <main className="content">
          <Routes>
            <Route path="/" element={<Home />} />
           
            <Route path="/order" element={<Order />} />
            
            <Route path="/product/:id" element={<ProductDetail />} />
            <Route path="/signin" element={<SignIn />} />
            <Route path="/signup" element={<SignUp />} />
            <Route path="/profile" element={<Profile />} />
            <Route path="/makeorder/:id" element={<MakeOrder />} />
            <Route path="/admin" element={<AdminHome />} />

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