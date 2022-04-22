DROP TABLE IF EXISTS characteristics;
DROP TABLE IF EXISTS photos;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS products;

-- create tables for schema

CREATE TABLE IF NOT EXISTS products (
  product_id BIGSERIAL NOT NULL PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS reviews (
  review_id BIGSERIAL NOT NULL PRIMARY KEY,
  product_id INT REFERENCES products(product_id),
  rating INT NOT NULL,
  date BIGINT NOT NULL,
  summary TEXT NOT NULL,
  body TEXT NOT NULL,
  recommend BOOLEAN NOT NULL,
  reported BOOLEAN NOT NULL,
  reviewer_name VARCHAR(100) NOT NULL,
  reviewer_email TEXT NOT NULL,
  response TEXT NOT NULL,
  helpfulness INT NOT NULL
);

CREATE TABLE IF NOT EXISTS photos (
  photo_id BIGSERIAL NOT NULL PRIMARY KEY,
  review_id INT REFERENCES reviews(review_id),
  url TEXT NOT NULL
);

-- hold raw extracted data from csv files

CREATE TABLE IF NOT EXISTS  raw_products (
  product_id BIGSERIAL NOT NULL PRIMARY KEY,
  name TEXT,
  slogan TEXT,
  description TEXT,
  category TEXT,
  default_price INT
);

CREATE TABLE IF NOT EXISTS characteristics (
  characteristic_id BIGSERIAL NOT NULL PRIMARY KEY,
  product_id INT NOT NULL REFERENCES products(product_id),
  name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS characteristic_reviews (
  id BIGSERIAL NOT NULL PRIMARY KEY,
  characteristic_id INT NOT NULL REFERENCES characteristics(characteristic_id),
  review_id INT NOT NULL REFERENCES reviews(review_id),
  value INT NOT NULL
);

-- copy csv data into raw tables

COPY raw_products
FROM '/Users/julian/Desktop/SDC_data/product.csv'
DELIMITER ',' CSV HEADER;

COPY reviews
FROM '/Users/julian/Desktop/SDC_data/reviews.csv'
DELIMITER ',' CSV HEADER;

COPY photos
FROM '/Users/julian/Desktop/SDC_data/reviews_photos.csv'
DELIMITER ',' CSV HEADER;

COPY characteristics
FROM '/Users/julian/Desktop/SDC_data/characteristics.csv'
DELIMITER ',' CSV HEADER;

COPY characteristic_reviews
FROM '/Users/julian/Desktop/SDC_data/characteristic_reviews.csv'
DELIMITER ',' CSV HEADER;

INSERT INTO products (product_id)
SELECT DISTINCT product_id
FROM raw_products;



