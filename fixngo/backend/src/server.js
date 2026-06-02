require('dotenv').config();
const express = require('express');
const cors = require('cors');
const colors = require('colors');
const connectDB = require('./config/db');
const routes = require('./routes');
const { errorHandler } = require('./middleware/errorMiddleware');

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

connectDB();

app.use(routes);

app.use(errorHandler);

const PORT = process.env.PORT || 5000;

const server = app.listen(PORT, () => {
  console.log(`Server running in ${process.env.NODE_ENV} mode on port ${PORT}`.yellow.bold);
});

module.exports = { app, server };
