/* Business Question #41 - Revenue Contribution by Category

-- Business Context
Management wants to understand
which product categories contribute the most revenue.

-- Business Question
How much revenue does each product category generate?
*/

-- QUERY

SELECT
    c.CategoryID,
    c.CategoryName,
    SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) AS TotalRevenue
FROM Orders o
INNER JOIN Products p
    ON o.ProductID = p.ProductID
INNER JOIN Categories c
    ON p.CategoryID = c.CategoryID
GROUP BY
    c.CategoryID,
    c.CategoryName
ORDER BY
    TotalRevenue DESC;
/* Business Question #42 - Category Profitability

-- Business Context
Management wants to evaluate
profitability across product categories.

-- Business Question
Which product categories generate the highest profit?
*/

-- QUERY

SELECT
    c.CategoryID,
    c.CategoryName,
    SUM(
        (o.UnitPrice - o.UnitCost)
        * o.Quantity
        * (1 - o.DiscountPct)
    ) AS TotalProfit
FROM Orders o
INNER JOIN Products p
    ON o.ProductID = p.ProductID
INNER JOIN Categories c
    ON p.CategoryID = c.CategoryID
GROUP BY
    c.CategoryID,
    c.CategoryName
ORDER BY
    TotalProfit DESC;
/* Business Question #43 - Best Product in Each Category

-- Business Context
Management wants to identify
the highest-performing product in each category.

-- Business Question
Which product generates the highest revenue within each category?
*/

-- QUERY

WITH ProductRevenue AS
(
    SELECT
        c.CategoryID,
        c.CategoryName,
        p.ProductID,
        p.ProductName,
        SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) AS TotalRevenue,
        ROW_NUMBER() OVER
        (
            PARTITION BY c.CategoryID
            ORDER BY
                SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) DESC
        ) AS RowNum
    FROM Orders o
    INNER JOIN Products p
        ON o.ProductID = p.ProductID
    INNER JOIN Categories c
        ON p.CategoryID = c.CategoryID
    GROUP BY
        c.CategoryID,
        c.CategoryName,
        p.ProductID,
        p.ProductName
)

SELECT
    CategoryID,
    CategoryName,
    ProductID,
    ProductName,
    TotalRevenue
FROM ProductRevenue
WHERE RowNum = 1
ORDER BY
    CategoryName;
/* Business Question #44 - Average Selling Price by Category

-- Business Context
Management wants to compare
pricing across product categories.

-- Business Question
What is the average transaction selling price for each category?
*/

-- QUERY

SELECT
    c.CategoryID,
    c.CategoryName,
    AVG(o.UnitPrice) AS AverageSellingPrice
FROM Orders o
INNER JOIN Products p
    ON o.ProductID = p.ProductID
INNER JOIN Categories c
    ON p.CategoryID = c.CategoryID
GROUP BY
    c.CategoryID,
    c.CategoryName
ORDER BY
    AverageSellingPrice DESC;
/* Business Question #45 - Category Sales Distribution

-- Business Context
Management wants to understand
sales volume across product categories.

-- Business Question
How many product units are sold in each category?
*/

-- QUERY

SELECT
    c.CategoryID,
    c.CategoryName,
    SUM(o.Quantity) AS TotalUnitsSold
FROM Orders o
INNER JOIN Products p
    ON o.ProductID = p.ProductID
INNER JOIN Categories c
    ON p.CategoryID = c.CategoryID
GROUP BY
    c.CategoryID,
    c.CategoryName
ORDER BY
    TotalUnitsSold DESC;
/* Business Question #46 - Category Revenue Ranking

-- Business Context
Management wants to rank
product categories by revenue.

-- Business Question
How does each category rank based on total revenue?
*/

-- QUERY

SELECT
    c.CategoryID,
    c.CategoryName,
    SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) AS TotalRevenue,
    RANK() OVER
    (
        ORDER BY
            SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) DESC
    ) AS RevenueRank
FROM Orders o
INNER JOIN Products p
    ON o.ProductID = p.ProductID
INNER JOIN Categories c
    ON p.CategoryID = c.CategoryID
GROUP BY
    c.CategoryID,
    c.CategoryName
ORDER BY
    RevenueRank;
/* Business Question #47 - Highest Quantity Sold by Category

-- Business Context
Management wants to identify
the categories with the highest sales volume.

-- Business Question
Which product categories sell the most units?
*/

-- QUERY

SELECT
    c.CategoryID,
    c.CategoryName,
    SUM(o.Quantity) AS TotalQuantitySold
FROM Orders o
INNER JOIN Products p
    ON o.ProductID = p.ProductID
INNER JOIN Categories c
    ON p.CategoryID = c.CategoryID
GROUP BY
    c.CategoryID,
    c.CategoryName
ORDER BY
    TotalQuantitySold DESC;
/* Business Question #48 - Average Discount by Category

-- Business Context
Management wants to evaluate
discount strategies across product categories.

-- Business Question
What is the average discount percentage applied to each category?
*/

-- QUERY

SELECT
    c.CategoryID,
    c.CategoryName,
    AVG(o.DiscountPct) AS AverageDiscount
FROM Orders o
INNER JOIN Products p
    ON o.ProductID = p.ProductID
INNER JOIN Categories c
    ON p.CategoryID = c.CategoryID
GROUP BY
    c.CategoryID,
    c.CategoryName
ORDER BY
    AverageDiscount DESC;
/* Business Question #49 - Monthly Sales by Category

-- Business Context
Management wants to monitor
monthly sales performance for each category.

-- Business Question
How does category revenue change each month?
*/

-- QUERY

SELECT
    c.CategoryID,
    c.CategoryName,
    YEAR(o.OrderDate) AS SalesYear,
    MONTH(o.OrderDate) AS SalesMonth,
    SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) AS MonthlyRevenue
FROM Orders o
INNER JOIN Products p
    ON o.ProductID = p.ProductID
INNER JOIN Categories c
    ON p.CategoryID = c.CategoryID
GROUP BY
    c.CategoryID,
    c.CategoryName,
    YEAR(o.OrderDate),
    MONTH(o.OrderDate)
ORDER BY
    c.CategoryName,
    SalesYear,
    SalesMonth;
/* Business Question #50 - Category Growth Rate

-- Business Context
Management wants to evaluate
monthly revenue growth for each product category.

-- Business Question
How does revenue grow month-over-month within each category?
*/

-- QUERY

WITH MonthlyCategoryRevenue AS
(
    SELECT
        c.CategoryID,
        c.CategoryName,
        YEAR(o.OrderDate) AS SalesYear,
        MONTH(o.OrderDate) AS SalesMonth,
        SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) AS TotalRevenue
    FROM Orders o
    INNER JOIN Products p
        ON o.ProductID = p.ProductID
    INNER JOIN Categories c
        ON p.CategoryID = c.CategoryID
    GROUP BY
        c.CategoryID,
        c.CategoryName,
        YEAR(o.OrderDate),
        MONTH(o.OrderDate)
)

SELECT
    CategoryID,
    CategoryName,
    SalesYear,
    SalesMonth,
    TotalRevenue,
    LAG(TotalRevenue) OVER
    (
        PARTITION BY CategoryID
        ORDER BY
            SalesYear,
            SalesMonth
    ) AS PreviousMonthRevenue,
    TotalRevenue
        - LAG(TotalRevenue) OVER
        (
            PARTITION BY CategoryID
            ORDER BY
                SalesYear,
                SalesMonth
        ) AS RevenueGrowth
FROM MonthlyCategoryRevenue
ORDER BY
    CategoryName,
    SalesYear,
    SalesMonth;
