import React from 'react';
import '../App.css';

const SignIn = () => {
    return (
        <div className="signin-container">
            <div className="signin-form">
                <h2>Sign In</h2>
                <form>
                    <div className="input-group">
                        <label htmlFor="email">Email</label>
                        <input type="email" id="email" name="email" required />
                    </div>
                    <div className="input-group">
                        <label htmlFor="password">Password</label>
                        <input type="password" id="password" name="password" required />
                    </div>
                    <button type="submit">Sign In</button>
                </form>
            </div>
        </div>
    );
};

export default SignIn;