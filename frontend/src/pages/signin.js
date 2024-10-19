// import React from 'react';
// import '../App.css';

// const SignIn = () => {
//     return (
//         <div className="signin-container">
//             <div className="signin-form">
//                 <h2>Sign In</h2>
//                 <form>
//                     <div className="input-group">
//                         <label htmlFor="email">Email</label>
//                         <input type="email" id="email" name="email" required />
//                     </div>
//                     <div className="input-group">
//                         <label htmlFor="password">Password</label>
//                         <input type="password" id="password" name="password" required />
//                     </div>
//                     <button type="submit">Sign In</button>
//                 </form>
//             </div>
//         </div>
//     );
// };

// export default SignIn;
import React, { useState } from 'react';
import '../App.css';

const SignIn = () => {
    const [formData, setFormData] = useState({
        username: '',
        password: ''
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
                // Redirect to another page or perform other actions
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