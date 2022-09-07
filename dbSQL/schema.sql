DROP DATABASE IF EXISTS sdc_overview;
CREATE DATABASE sdc_overview;


-- create products table
DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id int NOT NULL,
  "name" varchar(255) NULL DEFAULT NULL,
  slogan varchar(1000) NULL DEFAULT NULL,
  description varchar(1000) NULL DEFAULT NULL,
  category varchar(255) NULL DEFAULT NULL,
  default_price varchar(255) NULL DEFAULT NULL,
  PRIMARY KEY (id)
);
-- import the csv data into products table
\COPY products FROM '/Users/chrisbaharians/Desktop/data/product.csv' DELIMITER ',' CSV HEADER;

-- create features table
DROP TABLE IF EXISTS features;
CREATE TABLE features (
  feature_id int not null,
  product_id int not null,
  feature varchar(255) NULL DEFAULT NULL,
  "value" varchar(255) NULL DEFAULT NULL,
  PRIMARY KEY (feature_id)
);
-- import csv data into features table
\COPY features FROM '/Users/chrisbaharians/Desktop/data/features (1).csv' DELIMITER ',' CSV HEADER;

-- create styles table
DROP TABLE IF EXISTS styles;
CREATE TABLE styles (
  style_id int not null,
  product_id int NULL DEFAULT NULL,
  "name" varchar(255) NULL DEFAULT NULL,
  sale_price varchar(255) NULL DEFAULT NULL,
  original_price varchar(255) NULL DEFAULT NULL,
  "default?" boolean
);
-- import csv data into photos table
\COPY styles FROM '/Users/chrisbaharians/Desktop/data/styles.csv' DELIMITER ',' CSV HEADER;

DROP TABLE IF EXISTS related;
CREATE TABLE related (
  id int not null,
  product_id int not null,
  related_prod_id int NULL DEFAULT NULL,
  PRIMARY KEY (id)
);

\COPY related FROM '/Users/chrisbaharians/Desktop/data/related.csv' DELIMITER ',' CSV HEADER;

-- create photos table
DROP TABLE IF EXISTS photos;
CREATE TABLE photos (
  id int NOT NULL,
  style_id int,
  url TEXT DEFAULT NULL,
  thumbnail_url varchar NULL DEFAULT NULL
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
  prod.id,
  json_agg(json_build_object('feature', f.feature, 'value', f.value)) as features
FROM
  products AS prod JOIN features AS f ON f.product_id = prod.id
GROUP BY
  prod.id;



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
  p.id, p.name, p.slogan, p.description, p.category, p.default_price, af.features
FROM
  products AS p JOIN agg_feat AS af ON af.product_id = p.id;







-- use this for reference: https://www.w3schools.com/sql/sql_insert_into_select.asp


-- command to run the entire sql file
-- \i /Users/chrisbaharians/RPP36/rpp36-chris-overview/dbSQL/schema.sql







