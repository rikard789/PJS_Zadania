import React, { useEffect, useState } from 'react';
import axios from 'axios';
import ProductForm from './ProductForm';

const App = () => {
    const [products, setProducts] = useState([]);
    const [categories, setCategories] = useState([]);
    const [cart, setCart] = useState([]);
    const [totalAmount, setTotalAmount] = useState(0);

    useEffect(() => {
        const fetchProducts = async () => {
            const response = await axios.get('http://localhost:5000/api/products');
            setProducts(response.data);
        };

        const fetchCategories = async () => {
            const response = await axios.get('http://localhost:5000/api/categories');
            setCategories(response.data);
        };

        fetchProducts();
        fetchCategories();
    }, []);

    const addToCart = (item) => {
      setCart((prevCart) => [...prevCart, item]);
    };
  
    // Function to calculate the total amount
    const calculateTotal = () => {
      const total = cart.reduce((acc, item) => acc + item.price, 0);
      setTotalAmount(total);
    };
  
    // Function to handle the payment
    const handlePayment = () => {
      // Replace this with your actual payment logic
      alert('Payment successful!');
      // Clear the cart after payment
      setCart([]);
      setTotalAmount(0);
    };

    return (
        <div>
            <h1>Simple Shop</h1>

            <div>
                <h2>Categories</h2>
                <ul>
                    {categories.map((category, index) => (
                        <li key={index}>{category}</li>
                    ))}
                </ul>
            </div>

            <div>
                <h2>Products</h2>
                <ul>
                  {products.map((product) => (
                    <li key={product._id}>
                      {product.name} - ${product.price} - {product.category}
                      <button onClick={() => addToCart(product)}>Add to Cart</button>
                    </li>
                  ))}
                </ul>
            </div>

            <div>
              <h2>Shopping Cart</h2>
              <ul>
                {cart.map((product) => (
                  <li key={product._id}>
                    {product.name} - ${product.price}
                  </li>
                ))}
              </ul>
              <p>Total Amount: ${totalAmount}</p>
              <button onClick={calculateTotal}>Calculate Total</button>
              <button onClick={handlePayment} disabled={cart.length === 0}>
                Pay Now
              </button>
            </div>
            
            <ProductForm/>
        </div>
    );
};

export default App;

