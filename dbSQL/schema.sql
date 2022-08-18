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
\COPY products FROM '/Users/chrisbaharians/Desktop/data/styles.csv' DELIMITER ',' CSV HEADER;

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
  style_id int NOT NULL,
  product_id int,
  name varchar(255),
  sales_price varchar(255),
  original_price int,
  default_style boolean
);
-- import csv data into photos table
\COPY photos FROM '/Users/chrisbaharians/Desktop/data/photos (1).csv' DELIMITER ',' CSV HEADER;

-- create photos table
DROP TABLE IF EXISTS photos;
CREATE TABLE photos (
  id int NOT NULL,
  style_id int,
  url varchar,
  thumbnail_url varchar
);
-- import csv data into skus table
\COPY skus FROM '/Users/chrisbaharians/Desktop/data/.csv' DELIMITER ',' CSV HEADER;

--create skus table
DROP TABLE IF EXISTS skus;
CREATE TABLE skus (
  id int,
  style_id int,
  size varchar(255),
  quantity int
);


-- command to run the entire sql file
-- \i /Users/chrisbaharians/RPP36/rpp36-chris-overview/dbSQL/schema.sql







