create database papajohns;
use papajohns;
CREATE TABLE orders (
    order_id INT NOT NULL PRIMARY KEY,
    orderdate DATE NOT NULL,
    ordertime TIME NOT NULL
);

create table order_details(
order_details_id int not null primary key,
orderid int not null,
pizza_id text not null,
quantity int not null);
use papajohns;
show tables;

-- 1.Retrieve the total number of orders placed.

SELECT 
    COUNT(order_id) AS total_orders
FROM
    orders;
    
-- 2. Calculate total_revenue generated from pizza sales

SELECT 
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM
    order_details AS od
        INNER JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id;

-- 3. Identify the highest priced pizzas.

SELECT 
    pt.name, p.price
FROM
    pizza_types AS pt
        INNER JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;    

-- 4. Identify the most common pizza size ordered.

SELECT 
    p.size, COUNT(od.order_details_id) AS order_count
FROM
    pizzas AS p
        INNER JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY order_count DESC;    

-- 5. List the top 5 most ordered pizza types along with their quantities

SELECT 
    pt.name, SUM(od.quantity) AS quantity
FROM
    pizza_types AS pt
        INNER JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        INNER JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY quantity DESC
LIMIT 5;

-- 6. Join necessary tables to find total quantity of each pizza category

SELECT 
    pt.category AS category, SUM(od.quantity) AS quantity
FROM
    pizza_types AS pt
        INNER JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        INNER JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY category
ORDER BY quantity DESC;

-- 7. Determine the distribution of orders by hours of the day.

SELECT 
    HOUR(ordertime) AS hour, COUNT(order_id) order_count
FROM
    orders
GROUP BY hour
order by hour;

-- 8. Join relevant tables to find category wise distribution of pizzas

SELECT 
    category, COUNT(name) AS count
FROM
    pizza_types
GROUP BY category
ORDER BY count DESC;

-- 9. Group the orders by date and calculate the average number of pizzas ordered per day

SELECT 
    ROUND(AVG(quantity), 0) AS orders_per_day
FROM
    (SELECT 
        o.orderdate AS day, SUM(od.quantity) AS quantity
    FROM
        orders AS o
    INNER JOIN order_details AS od ON o.order_id = od.orderid
    GROUP BY day) AS order_quantity;
    
-- 10. Top 3 most ordered pizzas based on revenue

SELECT 
    pt.name, SUM(od.quantity * p.price) AS revenue
FROM
    pizza_types AS pt
        INNER JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        INNER JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;

-- 11. Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pt.category,
    ROUND(SUM(od.quantity * p.price) / (SELECT 
                    ROUND(SUM(od.quantity * p.price), 2) AS total_sales
                FROM
                    order_details AS od
                        INNER JOIN
                    pizzas AS p ON p.pizza_id = od.pizza_id) * 100,
            2) AS revenue
FROM
    pizza_types AS pt
        INNER JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        INNER JOIN
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY revenue DESC; 

-- 12. Determine the top 3 most ordered pizzas based on revenue for each pizza category

select rankk,name,category,revenue
from 
(select name,category,revenue,
rank() over(partition by category order by revenue) as rankk
from 
(SELECT 
    pt.name,pt.category, round(SUM(od.quantity * p.price)) AS revenue
FROM
    pizza_types AS pt
        INNER JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        INNER JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY pt.name,pt.category) as a) as b
where rankk <=3 ;    
    
    
    






