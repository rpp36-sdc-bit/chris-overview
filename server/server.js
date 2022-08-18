const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const db = require('./db')
const Pool = require('pg').Pool;
const pool = new Pool ({
  user: 'chrisbaharians',
  host: 'localhost',
  database: 'sdc_overview',
  password: 'password',
  port: 5432
});

// pool.connect()

app.get('/', (req, res) => {
  res.status(200).send('Hello World')
})

app.get('/products', (req, res) => {
  pool.query(`SELECT * FROM products LIMIT 5`, (error, results) => {
    if (error) {
      throw error
    }
    res.status(200).send(results.rows)
  })
});

app.get('/products/:id', (req, res) => {
  console.log('this is the req', req.params)
  pool.query(`SELECT * FROM products
    WHERE product_id = ${req.params.id}`, (error, data) => {
    if (error) {
      throw error
    }
    res.status(200).json(data.rows)
  })
})

app.get('products/:id/styles', (req, res) => {

})

// app.get('') make sure to implement this one for the related prods

app.listen(3000, () => {
  console.log('Listening on port 3000')
})

module.exports = app;