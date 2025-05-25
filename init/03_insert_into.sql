INSERT INTO dim_country (country_name)
SELECT customer_country
FROM raw_data
WHERE customer_country IS NOT NULL
GROUP BY customer_country
ON CONFLICT DO NOTHING;


INSERT INTO dim_customer (
    first_name, last_name, age, email, country_id,
    postal_code, pet_type, pet_name, pet_breed
)
SELECT
    MIN(r.customer_first_name),
    MIN(r.customer_last_name),
    MIN(r.customer_age),
    r.customer_email,
    c.country_id,
    MIN(r.customer_postal_code),
    MIN(r.customer_pet_type),
    MIN(r.customer_pet_name),
    MIN(r.customer_pet_breed)
FROM raw_data r
JOIN dim_country c ON r.customer_country = c.country_name
WHERE r.customer_email IS NOT NULL
GROUP BY r.customer_email, c.country_id
ON CONFLICT (email) DO NOTHING;


INSERT INTO dim_seller_country (country_name)
SELECT seller_country
FROM raw_data
WHERE seller_country IS NOT NULL
GROUP BY seller_country
ON CONFLICT DO NOTHING;


INSERT INTO dim_seller (
    first_name, last_name, email, seller_country_id, postal_code
)
SELECT
    MIN(r.seller_first_name),
    MIN(r.seller_last_name),
    r.seller_email,
    c.seller_country_id,
    MIN(r.seller_postal_code)
FROM raw_data r
JOIN dim_seller_country c ON r.seller_country = c.country_name
WHERE r.seller_email IS NOT NULL
GROUP BY r.seller_email, c.seller_country_id
ON CONFLICT (email) DO NOTHING;

INSERT INTO dim_store_country (country_name)
SELECT store_country
FROM raw_data
WHERE store_country IS NOT NULL
GROUP BY store_country
ON CONFLICT DO NOTHING;


INSERT INTO dim_store_city (city_name)
SELECT store_city
FROM raw_data
WHERE store_city IS NOT NULL
GROUP BY store_city
ON CONFLICT DO NOTHING;

INSERT INTO dim_store (
    store_name,
    store_location,
    store_city_id,
    store_country_id,
    store_state,
    store_phone,
    store_email
)
SELECT
    MIN(r.store_name),
    MIN(r.store_location),
    c.store_city_id,
    co.store_country_id,
    MIN(r.store_state),
    r.store_phone,
    MIN(r.store_email)
FROM raw_data r
JOIN dim_store_city c ON r.store_city = c.city_name
JOIN dim_store_country co ON r.store_country = co.country_name
WHERE r.store_phone IS NOT NULL
GROUP BY r.store_phone, c.store_city_id, co.store_country_id
ON CONFLICT (store_phone) DO NOTHING;


INSERT INTO dim_product_category (category_name)
SELECT product_category
FROM raw_data
WHERE product_category IS NOT NULL
GROUP BY product_category
ON CONFLICT DO NOTHING;

INSERT INTO dim_product_brand (brand_name)
SELECT product_brand
FROM raw_data
WHERE product_brand IS NOT NULL
GROUP BY product_brand
ON CONFLICT DO NOTHING;

INSERT INTO dim_product (
    product_name,
    product_category_id,
    product_brand_id,
    product_price,
    product_quantity,
    product_weight,
    product_color,
    product_size,
    product_material,
    product_description,
    product_rating,
    product_reviews,
    product_release_date,
    product_expiry_date
)
SELECT
    r.product_name,
    c.product_category_id,
    b.product_brand_id,
    r.product_price,
    MIN(r.product_quantity),
    r.product_weight,
    MIN(r.product_color),
    MIN(r.product_size),
    MIN(r.product_material),
    MIN(r.product_description),
    MIN(r.product_rating),
    MIN(r.product_reviews),
    MIN(r.product_release_date),
    MIN(r.product_expiry_date)
FROM raw_data r
JOIN dim_product_category c ON r.product_category = c.category_name
JOIN dim_product_brand b ON r.product_brand = b.brand_name
WHERE r.product_name IS NOT NULL
GROUP BY r.product_name, r.product_price, r.product_weight, c.product_category_id, b.product_brand_id
ON CONFLICT (product_name, product_price, product_weight) DO NOTHING;


INSERT INTO dim_pet_category (pet_category_name)
SELECT pet_category
FROM raw_data
WHERE pet_category IS NOT NULL
GROUP BY pet_category
ON CONFLICT DO NOTHING;

INSERT INTO dim_supplier_country (country_name)
SELECT supplier_country
FROM raw_data
WHERE supplier_country IS NOT NULL
GROUP BY supplier_country
ON CONFLICT DO NOTHING;


INSERT INTO dim_supplier (
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country_id
)
SELECT
    MIN(r.supplier_name),
    MIN(r.supplier_contact),
    r.supplier_email,
    MIN(r.supplier_phone),
    MIN(r.supplier_address),
    MIN(r.supplier_city),
    c.supplier_country_id
FROM raw_data r
JOIN dim_supplier_country c ON r.supplier_country = c.country_name
WHERE r.supplier_email IS NOT NULL
GROUP BY r.supplier_email, c.supplier_country_id
ON CONFLICT (supplier_email) DO NOTHING;

INSERT INTO fact_sales (
    sale_date,
    customer_id,
    seller_id,
    product_id,
    store_id,
    supplier_id,
    pet_category_id,
    sale_quantity,
    sale_total_price
)
SELECT
    r.sale_date,
    c.customer_id,
    s.seller_id,
    p.product_id,
    st.store_id,
    sup.supplier_id,
    pc.pet_category_id,
    r.sale_quantity,
    r.sale_total_price
FROM raw_data r
JOIN dim_customer c ON r.customer_email = c.email
JOIN dim_seller s ON r.seller_email = s.email
JOIN dim_product p
  ON r.product_name = p.product_name 
 AND r.product_price = p.product_price 
 AND r.product_weight = p.product_weight
JOIN dim_store st ON r.store_email = st.store_email
JOIN dim_supplier sup ON r.supplier_email = sup.supplier_email
JOIN dim_pet_category pc ON r.pet_category = pc.pet_category_name
WHERE r.sale_date IS NOT NULL;
