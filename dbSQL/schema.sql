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
DROP INDEX IF EXISTS idx_products_id;
CREATE INDEX idx_products_id ON products USING btree(id);

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
DROP INDEX IF EXISTS idx_features_id;
CREATE INDEX idx_features_id ON features USING btree (feature_id);

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
DROP INDEX IF EXISTS idx_styles_style_id;
CREATE INDEX idx_styles_style_id ON styles USING btree(style_id);
DROP INDEX IF EXISTS idx_styles_product_id;
CREATE INDEX idx_styles_product_id ON styles USING btree(product_id);

DROP TABLE IF EXISTS related;
CREATE TABLE related (
  id int not null,
  product_id int not null,
  related_prod_id int NULL DEFAULT NULL,
  PRIMARY KEY (id)
);

\COPY related FROM '/Users/chrisbaharians/Desktop/data/related.csv' DELIMITER ',' CSV HEADER;
DROP INDEX IF EXISTS idx_related_product_id;
CREATE INDEX idx_related_product_id ON related USING btree(product_id);
DROP INDEX IF EXISTS idx_related_related_product_id;
CREATE INDEX idx_related_related_product_id ON related USING btree (related_prod_id);

-- create photos table
DROP TABLE IF EXISTS photos;
CREATE TABLE photos (
  id int NOT NULL,
  style_id int,
  url TEXT DEFAULT NULL,
  thumbnail_url varchar NULL DEFAULT NULL
);

\COPY photos FROM '/Users/chrisbaharians/Desktop/data/photos (1).csv' DELIMITER ',' CSV HEADER;
DROP INDEX IF EXISTS idx_photos_id;
CREATE INDEX idx_photos_id ON photos USING btree (id);
DROP INDEX IF EXISTS idx_photos_style_id;
CREATE INDEX idx_photos_style_id ON photos USING btree (style_id);

--create skus table
DROP TABLE IF EXISTS skus;
CREATE TABLE skus (
  id int,
  style_id int,
  size varchar(255),
  quantity int
);

\COPY skus FROM '/Users/chrisbaharians/Desktop/data/skus.csv' DELIMITER ',' CSV HEADER;
DROP INDEX IF EXISTS idx_skus_style_id;
CREATE INDEX idx_skus_style_id ON skus USING btree (style_id);

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

DROP INDEX IF EXISTS idx_agg_feat_id;
CREATE INDEX idx_agg_feat_id ON agg_feat USING btree(product_id);



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

DROP INDEX IF EXISTS idx_aggregatedProducts_id;
CREATE INDEX idx_aggregatedProducts_id ON aggregatedProducts USING btree(id);
DROP INDEX IF EXISTS idx_aggregatedProducts_category;
CREATE INDEX idx_aggregatedProducts_category ON aggregatedProducts USING btree(category);
DROP INDEX IF EXISTS idx_aggregatedProducts_name;
CREATE INDEX idx_aggregatedProducts_name ON aggregatedProducts USING btree (name);


ALTER TABLE styles ADD FOREIGN KEY (product_id) REFERENCES products (id);
ALTER TABLE related ADD FOREIGN KEY (product_id) REFERENCES products(id);
ALTER TABLE features ADD FOREIGN KEY (product_id) REFERENCES products(id);







-- use this for reference: https://www.w3schools.com/sql/sql_insert_into_select.asp


-- command to run the entire sql file
-- \i /Users/chrisbaharians/RPP36/rpp36-chris-overview/dbSQL/schema.sql







