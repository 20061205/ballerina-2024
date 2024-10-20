import React, { useState, useEffect } from 'react';
import axios from 'axios';
import '../App.css';

function AdminHome() {
    const [orders, setOrders] = useState([]);
    const [statuses, setStatuses] = useState([]);

    useEffect(() => {
        // Fetch all order details from the backend
        const fetchOrders = async () => {
            try {
                const response = await axios.get('http://localhost:8080/juiceBar/getAllOrders');
                setOrders(response.data);
            } catch (error) {
                console.error('Error fetching orders:', error);
            }
        };

        // Fetch all possible statuses from the backend
        const fetchStatuses = async () => {
            try {
                const response = await axios.get('http://localhost:8080/juiceBar/getStatuses');
                setStatuses(response.data);
            } catch (error) {
                console.error('Error fetching statuses:', error);
            }
        };

        fetchOrders();
        fetchStatuses();
    }, []);

    const handleStatusChange = async (orderId, newStatusId) => {
        setOrders(prevOrders =>
            prevOrders.map(order =>
                order.order_id === orderId ? { ...order, status_id: newStatusId } : order
            )
        );
        console.log('Updating order status:', orderId, newStatusId);
        try {
            const response = await axios.post('http://localhost:8080/juiceBar/updateOrderStatus', {
                order_id: orderId,
                status_id: newStatusId
            });
            console.log('Response:', response);
            if (response.status === 200) {
                setOrders(prevOrders =>
                    prevOrders.map(order =>
                        order.order_id === orderId ? { ...order, status_id: newStatusId } : order
                    )
                );
                console.log(`Order status updated successfully for order ID: ${orderId}`);
            } else {
                console.error('Error updating order status:', response.data);
            }
        } catch (error) {
            console.error('Error updating order status:', error);
        }
    };

    const handleSelectChange = (orderId, newStatusId) => {
        setOrders(prevOrders =>
            prevOrders.map(order =>
                order.order_id === orderId ? { ...order, status_id: newStatusId } : order
            )
        );
    };

    return (
        <div className="admin-home">
            <h1>Admin Home</h1>
            <div className="order-grid">
                <table style={{ width: '100%' }}>
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>User ID</th>
                            <th>Ordered Date</th>
                            <th>Ordered Time</th>
                            <th>Delivery Time</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {orders.map(order => (
                            <tr key={order.order_id}>
                                <td>{order.order_id}</td>
                                <td>{order.user_id}</td>
                                <td>{order.ordered_date}</td>
                                <td>{order.ordered_time}</td>
                                <td>{order.dilivary_time}</td>
                                <td>
                                    <select
                                        value={order.status_id}
                                        onChange={e => handleSelectChange(order.order_id, e.target.value)}
                                        style={{ width: '100%' }}
                                    >
                                        {statuses.map(status => (
                                            <option key={status.status_id} value={status.status_id}>
                                                {status.status}
                                            </option>
                                        ))}
                                    </select>
                                </td>
                                <td>
                                    <button onClick={() => handleStatusChange(order.order_id, order.status_id)}>
                                        Update Status
                                    </button>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
}

export default AdminHome;