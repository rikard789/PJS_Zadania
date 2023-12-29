import React, { useEffect, useState } from 'react';
import axios from 'axios';
import ProductForm from './ProductForm';
import MyImage from './gun_shop.jpg';

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

  const calculateTotal = () => {
    const total = cart.reduce((acc, item) => acc + item.price, 0);
    setTotalAmount(total);
  };

  const handlePayment = () => {
    alert('Payment successful!');
    setCart([]);
    setTotalAmount(0);
  };

  return (
    <div style={styles.container}>
      <h1 style={styles.header}>Gun Shop</h1>
      <img src={MyImage} alt='' style={{ width: '500px', height: 'auto', margin: '10px' }}/>

      <div style={styles.section}>
        <h2>Categories</h2>
        <ul>
          {categories.map((category, index) => (
            <li key={index} style={styles.listItem}>{category}</li>
          ))}
        </ul>
      </div>

      <div style={styles.section}>
        <h2>Products</h2>
        <ul>
          {products.map((product) => (
            <li key={product._id} style={styles.productItem}>
              {product.name} - ${product.price} - {product.category}
              <button style={styles.addToCartButton} onClick={() => addToCart(product)}>
                Add to Cart
              </button>
            </li>
          ))}
        </ul>
      </div>

      <div style={styles.section}>
        <h2>Shopping Cart</h2>
        <ul>
          {cart.map((product) => (
            <li key={product._id} style={styles.cartItem}>
              {product.name} - ${product.price}
            </li>
          ))}
        </ul>
        <p style={styles.totalAmount}>Total Amount: ${totalAmount}</p>
        <button style={styles.calculateTotalButton} onClick={calculateTotal}>
          Calculate Total
        </button>
        <button style={styles.payNowButton} onClick={handlePayment} disabled={cart.length === 0}>
          Pay Now
        </button>
      </div>

      <ProductForm />
    </div>
  );
};

const styles = {
  container: {
    maxWidth: '800px',
    margin: '0 auto',
    padding: '20px',
    fontFamily: 'Arial, sans-serif',
  },
  header: {
    textAlign: 'center',
    fontSize: '24px',
    marginBottom: '20px',
  },
  section: {
    marginBottom: '30px',
  },
  listItem: {
    listStyle: 'none',
    margin: '5px 0',
  },
  productItem: {
    marginBottom: '10px',
  },
  addToCartButton: {
    marginLeft: '10px',
    cursor: 'pointer',
  },
  cartItem: {
    listStyle: 'none',
    margin: '5px 0',
  },
  totalAmount: {
    fontSize: '18px',
    fontWeight: 'bold',
  },
  calculateTotalButton: {
    marginRight: '10px',
    cursor: 'pointer',
  },
  payNowButton: {
    cursor: 'pointer',
    backgroundColor: '#4CAF50',
    color: 'white',
    padding: '10px 15px',
    border: 'none',
    borderRadius: '5px',
    fontSize: '16px',
    fontWeight: 'bold',
    outline: 'none',
    disabled: {
      backgroundColor: '#ccc',
      cursor: 'not-allowed',
    },
  },
};

export default App;