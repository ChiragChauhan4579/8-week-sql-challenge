CREATE SCHEMA pizza_runner;
SET search_path = pizza_runner;

DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  "runner_id" INTEGER,
  "registration_date" DATE
);
INSERT INTO runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" TIMESTAMP
);

INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

INSERT INTO runner_orders
  ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  "pizza_id" INTEGER,
  "pizza_name" TEXT
);
INSERT INTO pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" TEXT
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" TEXT
);
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');

-----------------------------------------------A---------------------------------------------------------------------------------

--How many pizzas were ordered?

SELECT COUNT(PIZZA_ID) AS PIZZAS_ORDERED FROM CUSTOMER_ORDERS;
  
--How many unique customer orders were made?

SELECT COUNT(DISTINCT order_id) AS order_count
FROM CUSTOMER_ORDERS;
 
--How many successful orders were delivered by each runner?

SELECT * FROM RUNNER_ORDERS
WHERE RUNNER_ID = 1

SELECT RUNNER_ID,COUNT(ORDER_ID) AS SUCCESSFUL_ORDERS FROM RUNNER_ORDERS
WHERE DURATION <> 'null'
GROUP BY RUNNER_ID
ORDER BY SUCCESSFUL_ORDERS DESC;

--How many of each type of pizza was delivered?

SELECT PIZZA_NAMES.PIZZA_ID,PIZZA_NAMES.PIZZA_NAME,COUNT(PIZZA_NAMES.PIZZA_ID) FROM PIZZA_NAMES
JOIN CUSTOMER_ORDERS 
ON CUSTOMER_ORDERS.PIZZA_ID = PIZZA_NAMES.PIZZA_ID
JOIN RUNNER_ORDERS
ON CUSTOMER_ORDERS.ORDER_ID = RUNNER_ORDERS.ORDER_ID
WHERE DURATION <> 'null'
GROUP BY PIZZA_NAMES.PIZZA_ID,PIZZA_NAMES.PIZZA_NAME;

--How many Vegetarian and Meatlovers were ordered by each customer?

SELECT CUSTOMER_ORDERS.CUSTOMER_ID,PIZZA_NAMES.PIZZA_NAME,COUNT(PIZZA_NAMES.PIZZA_ID) AS PIZZAS_ORDERED FROM CUSTOMER_ORDERS 
JOIN  PIZZA_NAMES
ON CUSTOMER_ORDERS.PIZZA_ID = PIZZA_NAMES.PIZZA_ID
JOIN RUNNER_ORDERS
ON CUSTOMER_ORDERS.ORDER_ID = RUNNER_ORDERS.ORDER_ID
WHERE DURATION <> 'null'
GROUP BY CUSTOMER_ORDERS.CUSTOMER_ID,PIZZA_NAMES.PIZZA_NAME
ORDER BY PIZZAS_ORDERED DESC;

--What was the maximum number of pizzas delivered in a single order?

SELECT * FROM CUSTOMER_ORDERS
SELECT ORDER_ID,COUNT(ORDER_ID) AS MAX_PIZZAS FROM CUSTOMER_ORDERS
GROUP BY ORDER_ID
ORDER BY MAX_PIZZAS DESC LIMIT 1;

--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT CUSTOMER_ID,COUNT(ORDER_ID) AS MIN_ONE_CHANGE FROM CUSTOMER_ORDERS
WHERE (EXCLUSIONS <> 'null' AND EXCLUSIONS <> '') OR (EXTRAS <> 'null' AND EXTRAS <> '')
GROUP BY CUSTOMER_ID;

SELECT CUSTOMER_ID,COUNT(ORDER_ID) as NO_CHANGES FROM CUSTOMER_ORDERS
WHERE (EXCLUSIONS = 'null' OR EXCLUSIONS = '') AND (EXTRAS = 'null' OR EXTRAS = '')
GROUP BY CUSTOMER_ID;

--How many pizzas were delivered that had both exclusions and extras?

SELECT COUNT(ORDER_ID) as BOTH_EXC_AND_EXT FROM CUSTOMER_ORDERS
WHERE (EXCLUSIONS <> 'null' AND EXCLUSIONS <> '') AND (EXTRAS <> 'null' AND EXTRAS <> '')

--What was the total volume of pizzas ordered for each hour of the day?

SELECT DATE_PART('hour', order_time::TIMESTAMP) AS hour_of_day, COUNT(*) AS pizza_count
FROM CUSTOMER_ORDERS
WHERE order_time IS NOT NULL
GROUP BY hour_of_day
ORDER BY hour_of_day;


--What was the volume of orders for each day of the week?

SELECT
  TO_CHAR(order_time, 'Day') AS day_of_week,
  COUNT(*) AS pizza_count
FROM CUSTOMER_ORDERS
GROUP BY 
  day_of_week, 
  DATE_PART('dow', order_time)
ORDER BY day_of_week;

-----------------------------------------------B---------------------------------------------------------------------------------

--How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT DISTINCT(COUNT(runner_id)) FROM RUNNERS

--What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT RUNNER_ORDERS.order_id,RUNNER_ORDERS.runner_id, split_part(RUNNER_ORDERS.pickup_time,' ', 2) AS ARRIVAL INTO ARRIVAL_TABLE
FROM RUNNER_ORDERS

SELECT * FROM ARRIVAL_TABLE

ALTER TABLE CUSTOMER_ORDERS 
ALTER COLUMN order_time 
TYPE text;

SELECT CUSTOMER_ORDERS.order_id,split_part(CUSTOMER_ORDERS.order_time,' ', 2) AS ORDER_TIME INTO ORDER_TABLE
FROM CUSTOMER_ORDERS

SELECT * FROM ORDER_TABLE

SELECT runner_id,Extract(day FROM (ARRIVAL_TABLE.ARRIVAL - ORDER_TABLE.ORDER_TIME))*24*60 AS minutes FROM ARRIVAL_TABLE
INNER JOIN ORDER_TABLE
ON ARRIVAL_TABLE.ORDER_ID = ORDER_TABLE.ORDER_ID;