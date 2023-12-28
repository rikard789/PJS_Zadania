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

createProducts()
async function createProducts() {
    const weapon1 = Product.create({
        name: 'HUNT GROUP DESTROYER VM15',
        price: 2500,
        category: 'Hunting weapon'
    })
    const weapon2 = Product.create({
        name: 'CZ 457 Varmint Synthetic 22LR',
        price: 2750,
        category: 'Hunting weapon'
    })
    const weapon3 = Product.create({
        name: 'Rewolwer Pietta 1851 Colt Navy Yank Steel .44',
        price: 1600,
        category: 'Black powder weapon'
    })
    const weapon4 = Product.create({
        name: 'CZ SCORPION EVO 3 A1',
        price: 7900,
        category: 'Machine gun'
    })
    const weapon5 = Product.create({
        name: 'STEN MK II',
        price: 2500,
        category: 'Machine gun'
    })
    console.log(weapon1)
}


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
