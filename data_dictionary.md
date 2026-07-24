# Data Dictionary

## customers

| Column | Type | Notes |
| --- | --- | --- |
| customer_id | text | Surrogate customer key used by orders |
| customer_unique_id | text | Real person identifier for repeat-purchase analysis |
| customer_state | text | Customer state |
| signup_date | date | Signup date |

## sellers

| Column | Type | Notes |
| --- | --- | --- |
| seller_id | text | Seller key |
| seller_state | text | Seller state |

## products

| Column | Type | Notes |
| --- | --- | --- |
| product_id | text | Product key |
| product_category_name | text | Category |
| product_weight_g | integer | Weight in grams |
| product_length_cm | integer | Length |
| product_height_cm | integer | Height |
| product_width_cm | integer | Width |

## orders

| Column | Type | Notes |
| --- | --- | --- |
| order_id | text | Order key |
| customer_id | text | FK to customers |
| order_status | text | Order status |
| order_purchase_timestamp | timestamp | Purchase time |
| order_approved_at | timestamp | Approval time |
| order_delivered_carrier_date | timestamp | Carrier pickup time |
| order_delivered_customer_date | timestamp | Delivered time |
| order_estimated_delivery_date | date | Estimated delivery date |

## order_items

| Column | Type | Notes |
| --- | --- | --- |
| order_id | text | FK to orders |
| order_item_id | integer | Item sequence within an order |
| product_id | text | FK to products |
| seller_id | text | FK to sellers |
| shipping_limit_date | timestamp | Shipping deadline |
| price | numeric(10,2) | Item price |
| freight_value | numeric(10,2) | Freight cost |

## payments

| Column | Type | Notes |
| --- | --- | --- |
| order_id | text | FK to orders |
| payment_sequential | integer | Payment sequence |
| payment_type | text | Payment method |
| payment_installments | integer | Installment count |
| payment_value | numeric(10,2) | Paid amount |

## reviews

| Column | Type | Notes |
| --- | --- | --- |
| review_id | text | Review key |
| order_id | text | FK to orders |
| review_score | integer | 1 to 5 |
| review_creation_date | date | Review date |
| review_comment_message | text | Free text comment |
