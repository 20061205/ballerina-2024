import React, { useState } from 'react';
import '../App.css';

const Signup = () => {
    const [formData, setFormData] = useState({
        first_name: '',
        last_name: '',
        username: '',
        password: '',
        email: '',
        user_type: '',
        phone_number: '',
    });

    const [message, setMessage] = useState('');
    const [isError, setIsError] = useState(false);

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
            const response = await fetch('http://localhost:8080/juiceBar/registerUser', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(formData),
            });

            if (response.ok) {
                const data = await response.json();
                setMessage('Signup successful!');
                setIsError(false);
                console.log('Form submitted:', data);
            } else {
                setMessage('Signup failed. Please try again.');
                setIsError(true);
            }
        } catch (error) {
            setMessage('Error submitting form. Please try again.');
            setIsError(true);
            console.error('Error submitting form:', error);
        }
    };

    return (
        <div className="signup-container">
            <form className="signup-form" onSubmit={handleSubmit}>
                <h2>Sign Up</h2>
                {message && (
                    <div className={isError ? 'error-message' : 'success-message'}>
                        {message}
                    </div>
                )}
                <div className="form-group">
                    <label htmlFor="first_name">First Name</label>
                    <input
                        type="text"
                        id="first_name"
                        name="first_name"
                        value={formData.first_name}
                        onChange={handleChange}
                        required
                    />
                </div>
                <div className="form-group">
                    <label htmlFor="last_name">Last Name</label>
                    <input
                        type="text"
                        id="last_name"
                        name="last_name"
                        value={formData.last_name}
                        onChange={handleChange}
                        required
                    />
                </div>
                <div className="form-group">
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
                <div className="form-group">
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
                <div className="form-group">
                    <label htmlFor="email">Email</label>
                    <input
                        type="email"
                        id="email"
                        name="email"
                        value={formData.email}
                        onChange={handleChange}
                        required
                    />
                </div>
                <div className="form-group">
                    <label>User Type</label>
                    <div>
                        <input
                            type="radio"
                            id="customer"
                            name="user_type"
                            value="customer"
                            checked={formData.user_type === 'customer'}
                            onChange={handleChange}
                            required
                        />
                        <label htmlFor="customer">Customer</label>
                    </div>
                    <div>
                        <input
                            type="radio"
                            id="admin"
                            name="user_type"
                            value="admin"
                            checked={formData.user_type === 'admin'}
                            onChange={handleChange}
                            required
                        />
                        <label htmlFor="admin">Admin</label>
                    </div>
                </div>
                <div className="form-group">
                    <label htmlFor="phone_number">Phone Number</label>
                    <input
                        type="text"
                        id="phone_number"
                        name="phone_number"
                        value={formData.phone_number}
                        onChange={handleChange}
                        required
                    />
                </div>
                <button type="submit">Register</button>
            </form>
        </div>
    );
};

export default Signup;