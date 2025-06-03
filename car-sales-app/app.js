// app.js
require('dotenv').config({ path: '/Users/levtolstoy/Development/DataBase/base_data_app/car-sales-app/.env' });

const express = require('express');
const bodyParser = require('body-parser');
const carRoutes = require('./routes/carRoutes');
const clientRoutes = require('./routes/clientRoutes');
const saleRoutes = require('./routes/saleRoutes');
const employeeRoutes = require('./routes/employeeRoutes');


// Логи
console.log('carRoutes:', carRoutes);
console.log('clientRoutes:', clientRoutes);
console.log('saleRoutes:', saleRoutes);
console.log('employeeRoutes', employeeRoutes);

const app = express();

app.use(bodyParser.json());

const morgan = require('morgan');
app.use(morgan('dev'));

// Маршруты
app.use('/api/cars', carRoutes);
app.use('/api/clients', clientRoutes);
app.use('/api/sales', saleRoutes);
app.use('/api/employees', employeeRoutes);

const PORT = process.env.PORT || 3000;

app.listen(3000, '0.0.0.0', () => {
    console.log('Server running on port 3000');
});
// app.listen(PORT, () => {
//     console.log(`Server is running on port ${PORT}`);
// });