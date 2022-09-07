const getData = (id, cb) => {
  let styles = []
  let skus = {}
  let photos = []
  let final = {}
  let allStyles = []
  let photoArray = []

  await pool.query(`SELECT * FROM styles
  WHERE product_id = ${id}`, async (err, data) => {
    if (err) {
      res.sendStatus(500);
    } else {
    styles = data.rows;

    styles.forEach(style => {
      allStyles.push(style.style_id);
    })

     allStyles.forEach(num => {
      pool.query(`SELECT * FROM skus
      WHERE style_id = ${num}`, (err, data) => {
        if (err) {
          res.sendStatus(500)
        } else {
          skus[num] = data.rows
          res.status(200)
        }
      })
    })

     allStyles.forEach(num => {
      pool.query(`SELECT * FROM photos
      WHERE style_id = ${num}`, (err, data) => {
        if (err) {
          res.sendStatus(500)
        } else {
          photoArray.push(...data.rows)
          res.status(200);
        }
      })
    })
  }
  res.status(200)
  })
  cb()
}