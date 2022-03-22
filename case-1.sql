CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  

--What is the total amount each customer spent at the restaurant?

SELECT SALES.CUSTOMER_ID,SUM(MENU.PRICE) AS SPENT FROM SALES
JOIN MENU
ON SALES.PRODUCT_ID=MENU.PRODUCT_ID
GROUP BY SALES.CUSTOMER_ID
ORDER BY SPENT DESC;

--How many days has each customer visited the restaurant?

SELECT SALES.CUSTOMER_ID,COUNT(DISTINCT to_char(SALES.ORDER_DATE,'DD,MM')) AS TIMES_VISITED FROM SALES
GROUP BY SALES.CUSTOMER_ID;

--What was the first item from the menu purchased by each customer?

SELECT customer_id,product_name,order_date INTO new_table
FROM (SELECT S.customer_id,S.order_date,M.product_name FROM sales as S
      LEFT JOIN menu as M ON S.product_id = M.product_id
      ORDER BY order_date) AS new_table;

SELECT * FROM new_table

SELECT customer_id,product_name,RANK() OVER(ORDER BY order_date) as rank_order INTO rank_table FROM new_table

SELECT * FROM rank_table

SELECT * FROM rank_table
WHERE rank_order = 1
GROUP BY customer_id,product_name,rank_order
ORDER BY customer_id;

--What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT MENU.PRODUCT_NAME,COUNT(MENU.PRODUCT_ID) AS TIMES_PURCHASED FROM SALES
JOIN MENU ON SALES.PRODUCT_ID=MENU.PRODUCT_ID
GROUP BY MENU.PRODUCT_NAME
ORDER BY TIMES_PURCHASED DESC LIMIT 1;

--Which item was the most popular for each customer?

With rank as
(
Select SALES.customer_ID ,
       MENU.product_name, 
       Count(SALES.product_id) as Count,
       Dense_rank()  Over (Partition by SALES.Customer_ID order by Count(SALES.product_id) DESC ) as Rank
From MENU 
join SALES
On MENU.product_id = SALES.product_id
group by SALES.customer_id,SALES.product_id,MENU.product_name
)

Select Customer_id,Product_name,Count
From rank
where rank = 1

--Which item was purchased first by the customer after they became a member?

SELECT SALES.CUSTOMER_ID,MENU.PRODUCT_NAME,SALES.ORDER_DATE,MEMBERS.JOIN_DATE,Dense_rank() OVER (Partition by SALES.CUSTOMER_ID Order by SALES.ORDER_DATE) as Rank INTO MEMBERSHIP FROM SALES
JOIN MENU ON SALES.PRODUCT_ID=MENU.PRODUCT_ID
JOIN MEMBERS ON SALES.CUSTOMER_ID=MEMBERS.CUSTOMER_ID
WHERE SALES.ORDER_DATE >= MEMBERS.JOIN_DATE
GROUP BY SALES.CUSTOMER_ID,SALES.ORDER_DATE,MEMBERS.JOIN_DATE,MENU.PRODUCT_NAME
ORDER BY SALES.ORDER_DATE;

SELECT CUSTOMER_ID,PRODUCT_NAME FROM MEMBERSHIP
WHERE RANK = 1;