const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const Pool = require('pg').Pool;
const pool = new Pool ({
  user: 'chrisbaharians',
  host: 'localhost',
  database: 'sdc_overview',
  password: 'password',
  port: 5432
});

// pool.connect()

app.use(express.json());

app.get('/', (req, res) => {
  res.status(200).send('Hello World')
})

app.get('/products', (req, res) => {
  pool.query(`SELECT * FROM products LIMIT 5`, (err, results) => {
    if (err) {
      throw err
    }
    res.status(200).json(results.rows)
  })
});

app.get('/products/:id', (req, res) => {
  let final = {}
  pool.query(`SELECT * FROM aggregatedProducts
    WHERE id = ${req.params.id}`, (err, data) => {
    if (err) {
      throw err
    }
    res.status(200).json(data.rows)
  })
})


app.get('/products/:id/styles', (req, res) => {
  pool.query(`SELECT * FROM styles
  WHERE product_id = ${req.params.id}`, (err, data) => {
    if (err) {
      throw err
    }
    console.log('this is the data i recieve for the styles', data.rows)
    res.status(200).json(data.rows)
  })
})

app.get('/products/:id/related', (req, res) => { // still need to create a related prod schema
  pool.query(`SELECT * FROM related
  WHERE product_id = ${req.params.id}`, (err, data) => {
    if (err) {
      throw err
    } else {
      let finalArr = [];
      data.rows.map(data => {
      finalArr.push(data.related_prod_id)
    })
    res.status(200).json(finalArr)
    }
  })
});

app.listen(3000, () => {
  console.log('Listening on port 3000')
})

module.exports = app;