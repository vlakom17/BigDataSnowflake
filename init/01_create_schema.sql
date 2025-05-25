CREATE TABLE IF NOT EXISTS raw_data (
    id INT,
    customer_first_name TEXT,
    customer_last_name TEXT,
    customer_age INT,
    customer_email TEXT,
    customer_country TEXT,
    customer_postal_code TEXT,
    customer_pet_type TEXT,
    customer_pet_name TEXT,
    customer_pet_breed TEXT,
    seller_first_name TEXT,
    seller_last_name TEXT,
    seller_email TEXT,
    seller_country TEXT,
    seller_postal_code TEXT,
    product_name TEXT,
    product_category TEXT,
    product_price DECIMAL,
    product_quantity INT,
    sale_date DATE,
    sale_customer_id INT,
    sale_seller_id INT,
    sale_product_id INT,
    sale_quantity INT,
    sale_total_price DECIMAL,
    store_name TEXT,
    store_location TEXT,
    store_city TEXT,
    store_state TEXT,
    store_country TEXT,
    store_phone TEXT,
    store_email TEXT,
    pet_category TEXT,
    product_weight DECIMAL,
    product_color TEXT,
    product_size TEXT,
    product_brand TEXT,
    product_material TEXT,
    product_description TEXT,
    product_rating DECIMAL,
    product_reviews INT,
    product_release_date DATE,
    product_expiry_date DATE,
    supplier_name TEXT,
    supplier_contact TEXT,
    supplier_email TEXT,
    supplier_phone TEXT,
    supplier_address TEXT,
    supplier_city TEXT,
    supplier_country TEXT
);

CREATE TABLE dim_country (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(255) UNIQUE
);

CREATE TABLE dim_customer (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    age INT,
    email VARCHAR(255) UNIQUE,
    country_id INT REFERENCES dim_country(country_id),
    postal_code VARCHAR(20),
    pet_type VARCHAR(255),
    pet_name VARCHAR(255),
    pet_breed VARCHAR(255)
);


CREATE TABLE dim_seller_country (
    seller_country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(255) UNIQUE
);

CREATE TABLE dim_seller (
    seller_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    seller_country_id INT REFERENCES dim_seller_country(seller_country_id),
    postal_code VARCHAR(20)
);


CREATE TABLE dim_store_country (
    store_country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(255) UNIQUE
);

CREATE TABLE dim_store_city (
    store_city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(255) UNIQUE
);

CREATE TABLE dim_store (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(255),
    store_location VARCHAR(255),
    store_city_id INT REFERENCES dim_store_city(store_city_id),
    store_country_id INT REFERENCES dim_store_country(store_country_id),
    store_state VARCHAR(100),
    store_phone VARCHAR(50) UNIQUE,
    store_email VARCHAR(255)
);

CREATE TABLE dim_product_category (
    product_category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(255) UNIQUE
);

CREATE TABLE dim_product_brand (
    product_brand_id SERIAL PRIMARY KEY,
    brand_name VARCHAR(255) UNIQUE
);

CREATE TABLE dim_product (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255),
    product_category_id INT REFERENCES dim_product_category(product_category_id),
    product_brand_id INT REFERENCES dim_product_brand(product_brand_id),
    product_price DECIMAL(10, 2),
    product_quantity INT,
    product_weight DECIMAL(10, 2),
    product_color VARCHAR(50),
    product_size VARCHAR(50),
    product_material VARCHAR(100),
    product_description TEXT,
    product_rating DECIMAL(3, 2),
    product_reviews INT,
    product_release_date DATE,
    product_expiry_date DATE,
    UNIQUE (product_name, product_price, product_weight)
);


CREATE TABLE dim_pet_category (
    pet_category_id SERIAL PRIMARY KEY,
    pet_category_name VARCHAR(255) UNIQUE
);



CREATE TABLE dim_supplier_country (
    supplier_country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(255) UNIQUE
);


CREATE TABLE dim_supplier (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(255),
    supplier_contact VARCHAR(255),
    supplier_email VARCHAR(255) UNIQUE,
    supplier_phone VARCHAR(50),
    supplier_address VARCHAR(255),
    supplier_city VARCHAR(255),
    supplier_country_id INT REFERENCES dim_supplier_country(supplier_country_id)
);


CREATE TABLE fact_sales (
    sale_id SERIAL PRIMARY KEY,
    sale_date DATE,
    customer_id INT REFERENCES dim_customer(customer_id),
    seller_id INT REFERENCES dim_seller(seller_id),
    product_id INT REFERENCES dim_product(product_id),
    store_id INT REFERENCES dim_store(store_id),
    supplier_id INT REFERENCES dim_supplier(supplier_id),
    pet_category_id INT REFERENCES dim_pet_category(pet_category_id),
    sale_quantity INT,
    sale_total_price DECIMAL(10, 2)
);