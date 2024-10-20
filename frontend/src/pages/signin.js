import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';

import '../App.css';

const SignIn = () => {
    const [formData, setFormData] = useState({
        username: '',
        password: ''
    });
    const [message, setMessage] = useState('');
    const [isError, setIsError] = useState(false);
    const navigate = useNavigate();

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData({
            ...formData,
            [name]: value,
        });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const response = await fetch('http://localhost:8080/juiceBar/checkUser', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(formData),
            });

            if (response.ok) {
                const data = await response.json();
                setMessage('Login successful!');
                setIsError(false);
                console.log('User details:', data);
                // Save user_id to localStorage
                localStorage.setItem('user_id', data.user_ID);
                localStorage.setItem('firstname', data.first_name);
                // Trigger a custom event to notify other components about the login status change
                const loginEvent = new CustomEvent('userLoggedIn', { detail: data });
                window.dispatchEvent(loginEvent);
                // Redirect based on user type
                if (data.user_type === 'admin') {
                    navigate('/admin');
                } else {
                    navigate('/');
                }
            } else {
                setMessage('Invalid login credentials. Please try again.');
                setIsError(true);
            }
        } catch (error) {
            setMessage('Error submitting form. Please try again.');
            setIsError(true);
            console.error('Error submitting form:', error);
        }
    };

    return (
        <div className="signin-container">
            <div className="signin-form">
                <h2>Sign In</h2>
                {message && (
                    <div className={isError ? 'error-message' : 'success-message'}>
                        {message}
                    </div>
                )}
                <form onSubmit={handleSubmit}>
                    <div className="input-group">
                        <label htmlFor="username">Username</label>
                        <input
                            type="text"
                            id="username"
                            name="username"
                            value={formData.username}
                            onChange={handleChange}
                            required
                        />
                    </div>
                    <div className="input-group">
                        <label htmlFor="password">Password</label>
                        <input
                            type="password"
                            id="password"
                            name="password"
                            value={formData.password}
                            onChange={handleChange}
                            required
                        />
                    </div>
                    <button type="submit">Sign In</button>
                </form>
            </div>
        </div>
    );
};

export default SignIn;