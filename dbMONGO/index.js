const mongoose = require('mongoose');
mongoose.connect('mongodb://127.0.0.1', { useNewUrlParser: true, useUnifiedTopology: true});

let productsSchema = new mongoose.Schema({
  product_id: {
    type: Number,
    unique: true
  },
  name: {type: String},
  slogan: {type: String},
  description: {type: String},
  default_price: {type: String}
})

let featuresSchema = new mongoose.Schema({
  feature_id: {type: Number},
  feature: {type: String}
  value: {type: String}
})

let stylesSchema = new mongoose.Schema({
  id: {type: Number, unique: true},
  product_id: {type: Number},
  name: {type: String},
  sales_price: {type: String, default: null},
  original_price: {type: String},
  default: {type: Boolean},
})

let photoSchema = new mongoose.Schema({
  style_id: {type: Number},
  thumbnail_url: {type: String},
  url: {type: String}
})

let skus = new mongoose.Schema({
  style_id: {type: Number},
  size: {type: String},
  quantity: {type: Number}
})



let product = mongoose.model('Product', productsSchema);
let feature = mongoose.model('Feature', featuresSchema);
let style = mongoose.model('Style', stylesSchema);
let photo = mongoose.model('Photo', photoSchema);
let skus = mongoose.model('Skus', skus);

module.exports = {
  product,
  feature,
  style,
  photo,
  skus
}
