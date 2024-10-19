import React, { useState, useEffect } from 'react';
import '../App.css';

const Profile = () => {
    const [userDetails, setUserDetails] = useState(null);

    useEffect(() => {
        const userId = localStorage.getItem('user_id');
        if (userId) {
            // Fetch user details from the backend
            fetch(`http://localhost:8080/juiceBar/getUserDetails?user_id=${userId}`)
                .then(response => response.json())
                .then(data => setUserDetails(data))
                .catch(error => console.error('Error fetching user details:', error));
        }
    }, []);

    if (!userDetails) {
        return <div>Loading...</div>;
    }

    return (
        <div className="profile-container">
            <h2>User Profile</h2>
            <p>Username: {userDetails.username}</p>
            <p>Email: {userDetails.email}</p>
            <p>First Name: {userDetails.first_name}</p>
            <p>Last Name: {userDetails.last_name}</p>
            <p>Phone Number: {userDetails.phone_number}</p>
        </div>
    );
};

export default Profile;