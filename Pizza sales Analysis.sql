--/* BASIC QUESTIONS */
-- Q1.Retrieve the total number of orders placed.

SELECT 
    COUNT(order_id) AS Total_Orders
FROM
    orders;




-- Q.2 Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS Total_Revenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;
    
    
   
   
-- Q.3 Identify the highest-priced pizza.

    SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;




-- Q.4 Identify the most common pizza size ordered.

SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS Order_Count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY Order_Count DESC;




-- Q.5 List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pizza_types.name, SUM(order_details.quantity) AS Quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY Quantity DESC
LIMIT 5;



/* Intermediate Questions */
-- Q.1 Join the necessary tables to find the 
       -- total quantity of each pizza category ordered.

SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS Quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY category
ORDER BY quantity DESC;




-- Q.2 Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS Hour, COUNT(order_id) AS Order_Count
FROM
    orders
GROUP BY HOUR(order_time);




-- Q.3 Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;





-- Q.4 Group the orders by date and calculate the average number
    -- of pizzas ordered per day.

SELECT 
    ROUND(AVG(quantity), 0) AS Avg_Pizza_Ordered_per_day
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS Order_Quantity;
    
    
    
    
    
   -- Q.5 Determine the top 3 most ordered pizza types based on revenue.
   
  SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS Revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;






/* Advanced Questions */
-- Q.1 Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                2) AS Total_Revenue
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,
            2) AS Revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY Revenue DESC;






-- Q.2 Analyze the cumulative revenue generated over time.

SELECT order_date,
sum(Revenue) OVER(ORDER BY order_date) AS Cummulative_Revenue
FROM 
(SELECT orders.order_date,
sum(order_details.quantity * pizzas.price) AS Revenue
FROM order_details JOIN pizzas
ON order_details.pizza_id = pizzas.pizza_id
JOIN orders
ON orders.order_id = order_details.order_id
GROUP BY orders.order_date) AS Sales;





-- Q.3 Determine the top 3 most ordered pizza types
       -- based on revenue for each pizza category.
       
 SELECT name, revenue
 FROM
 (SELECT category, name, revenue,
 RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS RN
 FROM
 (SELECT pizza_types.category, pizza_types.name,
 sum(order_details.quantity * pizzas.price) AS Revenue
 FROM pizza_types JOIN pizzas
 ON pizza_types.pizza_type_id = pizzas.pizza_type_id
 JOIN order_details
 ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category, pizza_types.name) AS A) AS AA
 WHERE RN <= 3;
