import React, { useState } from 'react';
import axios from 'axios';


// component added to test cors from frontend side
const ProductForm = () => {
    const [productName, setProductName] = useState('');

    const handleAddProduct = async () => {
        try {
            await axios.put('http://localhost:5000/api/products', { name: productName });
            console.log('Product added successfully!');
        } catch (error) {
            console.error('Error adding product:', error);
        }
    };

    return (
        <div>
            <h2>Add Product</h2>
            <input
                type="text"
                placeholder="Product Name"
                value={productName}
                onChange={(e) => setProductName(e.target.value)}
            />
            <button onClick={handleAddProduct}>Add Product</button>
        </div>
    );
};

export default ProductForm;