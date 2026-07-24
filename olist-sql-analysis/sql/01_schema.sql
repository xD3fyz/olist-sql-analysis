DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS sellers;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id text PRIMARY KEY,
    customer_unique_id text NOT NULL,
    customer_state text NOT NULL,
    signup_date date NOT NULL
);

CREATE TABLE sellers (
    seller_id text PRIMARY KEY,
    seller_state text NOT NULL
);

CREATE TABLE products (
    product_id text PRIMARY KEY,
    product_category_name text NOT NULL,
    product_weight_g integer,
    product_length_cm integer,
    product_height_cm integer,
    product_width_cm integer
);

CREATE TABLE orders (
    order_id text PRIMARY KEY,
    customer_id text NOT NULL REFERENCES customers(customer_id),
    order_status text NOT NULL,
    order_purchase_timestamp timestamp NOT NULL,
    order_approved_at timestamp,
    order_delivered_carrier_date timestamp,
    order_delivered_customer_date timestamp,
    order_estimated_delivery_date date NOT NULL
);

CREATE TABLE order_items (
    order_id text NOT NULL REFERENCES orders(order_id),
    order_item_id integer NOT NULL,
    product_id text NOT NULL REFERENCES products(product_id),
    seller_id text NOT NULL REFERENCES sellers(seller_id),
    shipping_limit_date timestamp,
    price numeric(10,2) NOT NULL,
    freight_value numeric(10,2) NOT NULL,
    PRIMARY KEY (order_id, order_item_id)
);

CREATE TABLE payments (
    order_id text NOT NULL REFERENCES orders(order_id),
    payment_sequential integer NOT NULL,
    payment_type text NOT NULL,
    payment_installments integer NOT NULL,
    payment_value numeric(10,2) NOT NULL,
    PRIMARY KEY (order_id, payment_sequential)
);

CREATE TABLE reviews (
    review_id text PRIMARY KEY,
    order_id text NOT NULL REFERENCES orders(order_id),
    review_score integer NOT NULL CHECK (review_score BETWEEN 1 AND 5),
    review_creation_date date NOT NULL,
    review_comment_message text
);
