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

const formatStyles = () => {

}

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

  let styles = []
  let skus = []
  let photos = []
  let final = {}
  let style_id = 0;

  pool.query(`SELECT * FROM styles
  WHERE product_id = ${req.params.id}`, (err, data) => {
    if (err) {
      throw err
    }
    styles = data.rows;
    res.status(200)
  })
  pool.query(`SELECT * FROM skus
  WHERE style_id = ${req.params.id}`, (err, data) => {
    if (err) {
      throw err;
    } else {
      skus = data.rows;
      style_id = skus[0].style_id;
      pool.query(`SELECT * FROM photos
       WHERE style_id = ${req.params.id}`, (err, data) => {
        if (err) {
         throw err;
        } else {
          photos = data.rows;
          console.log('these are the styles', styles);
          console.log('these are the skuses', skus);
          console.log('these are the photos', photos);
          styles.forEach((item) => {
            for (var i = 0; i < skus.length; i++) {
              let curr = skus[i];
              for (var j = 0; j < photos.length; j++) {
                let currPic = photos[j];
                if (item.style_id === currPic.id) {
                  item['photos'] = currPic;
                }
                if (item.style_id === curr.id) {
                  item['skus'] = curr;
                }
              }
            }
          })
         final['product_id'] = req.params.id;
         final['results'] = styles;
        //  console.log('this is the final obj', final);
         res.status(200).send(final);
       }
     })
    }
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