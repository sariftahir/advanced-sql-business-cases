/* Business Question #1 - Monthly Sales Trend

--Business Context
The Sales Director wants to monitor monthly 
sales performance to identify growth patterns 
and seasonal trends.

--Business Question
How much revenue was generated each month? */

-- QUERY

SELECT
    YEAR(OrderDate) AS SalesYear,
    MONTH(OrderDate) AS SalesMonth,
    SUM(Quantity * UnitPrice * (1 - DiscountPct)) AS TotalRevenue
FROM Orders
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    SalesYear,
    SalesMonth;



/* Business Question #2 - Total Revenue by Category

-- Business Context
Management wants to understand which product categories 
contribute the most revenue.

-- Business Question
Which product categories generate the highest revenue? */

-- QUERY 

SELECT
    c.CategoryName,
    SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) AS TotalRevenue
FROM Orders o
JOIN Products p
    ON o.ProductID = p.ProductID
JOIN Categories c
    ON p.CategoryID = c.CategoryID
GROUP BY
    c.CategoryName
ORDER BY
    TotalRevenue DESC;



/* Business Question #3 - Top Selling Products

-- Business Context
The Product Manager wants to identify the products 
with the highest sales volume to support inventory 
planning and purchasing decisions.

-- Business Question
Which products have sold the highest number of units? */


-- QUERY

SELECT TOP 10
    p.ProductName,
    SUM(o.Quantity) AS TotalUnitsSold
FROM Orders o
INNER JOIN Products p
    ON o.ProductID = p.ProductID
GROUP BY
    p.ProductName
ORDER BY
    TotalUnitsSold DESC;



/* Business Question #4 - Highest Revenue Products

-- Business Context
The Product Manager wants to identify which products
generate the highest revenue so the company can focus
on promoting and maintaining its best-performing products.

-- Business Question
Which products generated the highest total revenue?
*/

-- QUERY

SELECT
    p.ProductID,
    p.ProductName,
    SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) AS TotalRevenue
FROM Orders o
INNER JOIN Products p
    ON o.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.ProductName
ORDER BY
    TotalRevenue DESC;



/* Business Question #5 - Average Order Value

-- Business Context
The Finance Manager wants to understand the average
value of each order to evaluate customer purchasing behavior.

-- Business Question
What is the average revenue generated per order?
*/

-- QUERY

SELECT
    AVG(OrderRevenue) AS AverageOrderValue
FROM
(
    SELECT
        OrderID,
        SUM(Quantity * UnitPrice * (1 - DiscountPct)) AS OrderRevenue
    FROM Orders
    GROUP BY OrderID
) AS X;



/* Business Question #6 - Daily Sales Performance

-- Business Context
The Sales Director wants to monitor daily sales
performance to identify peak and slow sales periods.

-- Business Question
How much revenue was generated each day?
*/

-- QUERY

SELECT
    OrderDate,
    SUM(Quantity * UnitPrice * (1 - DiscountPct)) AS TotalRevenue
FROM Orders
GROUP BY
    OrderDate
ORDER BY
    OrderDate;



/* Business Question #7 - Monthly Revenue Growth (MoM)

-- Business Context
The Executive Team wants to measure month-over-month
revenue growth to evaluate business performance over time.

-- Business Question
How did revenue change compared to the previous month?
*/

-- QUERY

WITH MonthlySales AS
(
    SELECT
        YEAR(OrderDate) AS SalesYear,
        MONTH(OrderDate) AS SalesMonth,
        SUM(Quantity * UnitPrice * (1 - DiscountPct)) AS TotalRevenue
    FROM Orders
    GROUP BY
        YEAR(OrderDate),
        MONTH(OrderDate)
)

SELECT
    SalesYear,
    SalesMonth,
    TotalRevenue,
    LAG(TotalRevenue) OVER
    (
        ORDER BY SalesYear, SalesMonth
    ) AS PreviousMonthRevenue,
    TotalRevenue
    -
    LAG(TotalRevenue) OVER
    (
        ORDER BY SalesYear, SalesMonth
    ) AS RevenueGrowth
FROM MonthlySales
ORDER BY
    SalesYear,
    SalesMonth;



/* Business Question #8 - Top Sales Days

-- Business Context
The Sales Manager wants to identify the highest-performing
sales days to understand when customer demand peaks.

-- Business Question
Which days generated the highest revenue?
*/

-- QUERY

SELECT TOP 10
    OrderDate,
    SUM(Quantity * UnitPrice * (1 - DiscountPct)) AS TotalRevenue
FROM Orders
GROUP BY
    OrderDate
ORDER BY
    TotalRevenue DESC;



/* Business Question #9 - Revenue Contribution by Category

-- Business Context
The Product Manager wants to understand how much each
product category contributes to total company revenue.

-- Business Question
How much revenue did each product category generate?
*/

-- QUERY

SELECT
    c.CategoryName,
    SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) AS TotalRevenue
FROM Orders o
INNER JOIN Products p
    ON o.ProductID = p.ProductID
INNER JOIN Categories c
    ON p.CategoryID = c.CategoryID
GROUP BY
    c.CategoryName
ORDER BY
    TotalRevenue DESC;



/* Business Question #10 - Sales Performance by Employee

-- Business Context
The Sales Director wants to evaluate employee performance
based on the revenue they generated.

-- Business Question
Which employees generated the highest sales revenue?
*/

-- QUERY

SELECT
    e.EmployeeID,
    e.EmployeeName,
    SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) AS TotalRevenue
FROM Orders o
INNER JOIN Employees e
    ON o.EmployeeID = e.EmployeeID
GROUP BY
    e.EmployeeID,
    e.EmployeeName
ORDER BY
    TotalRevenue DESC;
