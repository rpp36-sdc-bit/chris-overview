const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const Pool = require('pg').Pool;
require('dotenv').config()
const pool = new Pool ({
  user: process.env.USER,
  host: process.env.HOST,
  database: process.env.DATABASE,
  password: process.env.PASSWORD,
  port: process.env.port
});


// pool.connect()

app.use(express.json());

app.get('/', (req, res) => {
  res.status(200).send('Hello World')
})

// API QUERY FOR PRODUCTS LIMIT 5
app.get('/products', (req, res) => {
  pool.query(`SELECT * FROM products LIMIT 5`, (err, results) => {
    if (err) {
      res.sendStatus(500);
    }
    res.status(200).json(results.rows)
  })
});

// API QUERY FOR SINGLE PRODUCT
app.get('/products/:id', (req, res) => {
  let final = {}
  pool.query(`SELECT * FROM aggregatedProducts
    WHERE id = ${req.params.id}`, (err, data) => {
    if (err) {
      res.sendStatus(500);
    }
    res.status(200).json(data.rows[0])
  })
})

// API QUERY FOR STYLES
app.get('/products/:id/styles', async (req, res) => {
  let skus = {}
  let photos = []
  let final = {}
  let photoArray = []

  const styles1 = await pool.query(`SELECT * FROM styles WHERE product_id = ${req.params.id}`)
  let styles = styles1.rows
  const allStyleIds = styles1.rows.map(style => style.style_id)

  const skuProms = allStyleIds.map(id => pool.query(`SELECT * FROM skus WHERE style_id = ${id}`))
  const skusData = await Promise.all(skuProms)
  const skusMap = {}
  skusData.forEach((item, i) => {
    skusMap[allStyleIds[i]] = item.rows;
  })

  const photoProms = allStyleIds.map(id => pool.query(`SELECT * FROM photos WHERE style_id = ${id}`))
  const photoData = await Promise.all(photoProms)
  const photoMap = {}
  photoData.forEach((item, i) => {
    photoMap[allStyleIds[i]] = item.rows;
  })

    styles.forEach(item => {
      const photos = photoMap[item.style_id]
      item.photos = photos.map(photo => ({
        'thumbnail_url': photo.thumbnail_url,
        'url': photo.url
      }))
      const skus = skusMap[item.style_id]
      const skusObj = {}
      skus.forEach(sku => skusObj[sku.id] = {
        quantity: sku.quantity,
        size: sku.size
      })
      item.skus = skusObj;
    })

    final['product_id'] = req.params.id;
    final['results'] = styles;
    if (!final.results.length) {
      final.results = null;
      res.sendStatus(500)
    } else {
    res.status(200).send(final);
    }
})

 // DB QUERY FOR RELATED PRODUCTS
app.get('/products/:id/related', (req, res) => {
  let id;
  if (req.query.productId === undefined) {
    id = req.params.id;
  } else {
    id = req.query.productId;
  }
  pool.query(`SELECT * FROM related
  WHERE product_id = ${id}`, (err, data) => {
    if (err) {
      res.status(500).send(err)
    } else {
      let finalArr = [];
      data.rows.map(data => {
      finalArr.push(data.related_prod_id)
    })
    res.status(200).json(finalArr)
    }
  })
});

app.listen(3001, () => {
  console.log('Listening on port 3001')
})

module.exports = app;




