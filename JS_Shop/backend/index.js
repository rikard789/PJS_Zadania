const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
const PORT = 5000;

// used GET and POST for shop to work and to check if OPTIONS and PUT are blocked 
app.use(cors({
    origin: "*",
    methods: ["GET", "POST"]
}));
app.use(express.json());

mongoose.connect('mongodb://localhost:27017/simple_shop', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
})
.then(db => console.log('DB is connected'))
.catch(err => console.log(err));

const ProductSchema = new mongoose.Schema({
    name: String,
    price: Number,
    category: String,
});

const Product = mongoose.model('Product', ProductSchema);

const createProduct = async (name, price, category) => {
    try {
        const product = await Product.create({ name, price, category });
        console.log('Product created:', product);
    } catch (error) {
        if (error.code === 11000 && error.keyPattern && error.keyPattern.name) {
            console.log('Product with the same name already exists.');
        } else {
            console.error('Error creating product:', error.message);
        }
    }
};
//populating database with products
createProduct('HUNT GROUP DESTROYER VM15', 2500, 'Hunting weapon');
createProduct('CZ 457 Varmint Synthetic 22LR', 2750, 'Hunting weapon');
createProduct('Rewolwer Pietta 1851 Colt Navy Yank Steel .44', 1600, 'Black powder weapon');
createProduct('CZ SCORPION EVO 3 A1', 7900, 'Machine gun');
createProduct('STEN MK II', 2500, 'Machine gun');

app.get('/api/products', async (req, res) => {
    const products = await Product.find();
    res.json(products);
});

app.get('/api/categories', async (req, res) => {
    const categories = await Product.distinct('category');
    res.json(categories);
});

// cors backend test block
app.put('/api/products', cors(), async (req, res) => {
    setTimeout(() => {
        res.status(201).json({ message: 'Product added successfully!' });
    }, 1000);
});

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
