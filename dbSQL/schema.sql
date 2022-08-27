DROP DATABASE IF EXISTS sdc_overview;
CREATE DATABASE sdc_overview;


-- create products table
DROP TABLE IF EXISTS products;
CREATE TABLE products (
  product_id int NOT NULL,
  prodName varchar(255),
  slogan varchar(1000),
  description varchar(1000),
  category varchar(255),
  default_price varchar(255),
  PRIMARY KEY (product_id)
);
-- import the csv data into products table
\COPY products FROM '/Users/chrisbaharians/Desktop/data/products.csv' DELIMITER ',' CSV HEADER;

-- create features table
DROP TABLE IF EXISTS features;
CREATE TABLE features (
  feature_id int,
  product_id int,
  feature varchar(255),
  value varchar(255),
  PRIMARY KEY (feature_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);
-- import csv data into features table
\COPY features FROM '/Users/chrisbaharians/Desktop/data/features (1).csv' DELIMITER ',' CSV HEADER;

-- create styles table
DROP TABLE IF EXISTS styles;
CREATE TABLE styles (
  style_id int,
  product_id int,
  name varchar(255),
  sales_price varchar(255),
  original_price int,
  default_style boolean
);
-- import csv data into photos table
\COPY styles FROM '/Users/chrisbaharians/Desktop/data/styles.csv' DELIMITER ',' CSV HEADER;

DROP TABLE IF EXISTS related;
CREATE TABLE related (
  id int,
  product_id int,
  related_prod_id int
);

\COPY related FROM '/Users/chrisbaharians/Desktop/data/related.csv' DELIMITER ',' CSV HEADER;

-- create photos table
DROP TABLE IF EXISTS photos;
CREATE TABLE photos (
  id int NOT NULL,
  style_id int,
  url varchar,
  thumbnail_url varchar
);

\COPY photos FROM '/Users/chrisbaharians/Desktop/data/photos (1).csv' DELIMITER ',' CSV HEADER;

--create skus table
DROP TABLE IF EXISTS skus;
CREATE TABLE skus (
  id int,
  style_id int,
  size varchar(255),
  quantity int
);

\COPY skus FROM '/Users/chrisbaharians/Desktop/data/skus.csv' DELIMITER ',' CSV HEADER;

-- aggregated features schema for inserting data into agg prods
DROP TABLE IF EXISTS agg_feat;
CREATE TABLE agg_feat (
  product_id int,
  features JSON
);

-- inserting data into agg features schema
INSERT INTO agg_feat
SELECT
  prod.product_id,
  json_agg(json_build_object('feature', f.feature, 'value', f.value)) as features
FROM
  products AS prod JOIN features AS f ON f.product_id = prod.product_id
GROUP BY
  prod.product_id;



-- aggregated products schema that should return the correct data in the correct format
DROP TABLE IF EXISTS aggregatedProducts;
CREATE TABLE aggregatedProducts (
  id int,
  name varchar(255),
  slogan varchar(1000),
  description varchar(1000),
  category varchar(255),
  default_price varchar(255),
  features JSON
);

-- insert all data into the agg prod schema
INSERT INTO aggregatedProducts
SELECT
  p.product_id, p.prodName, p.slogan, p.description, p.category, p.default_price, af.features
FROM
  products AS p JOIN agg_feat AS af ON af.product_id = p.product_id;

  -- agg styles




-- use this for reference: https://www.w3schools.com/sql/sql_insert_into_select.asp


-- command to run the entire sql file
-- \i /Users/chrisbaharians/RPP36/rpp36-chris-overview/dbSQL/schema.sql







