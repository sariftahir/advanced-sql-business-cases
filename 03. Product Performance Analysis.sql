/* Business Question #21 - Best Selling Products

-- Business Context
Management wants to identify the best selling products
to optimize inventory planning and promotional strategies.

-- Business Question
Which products have sold the highest total quantity?
*/

-- QUERY

SELECT
    p.ProductID,
    p.ProductName,
    SUM(o.Quantity) AS TotalQuantitySold
FROM Orders o
INNER JOIN Products p
    ON o.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.ProductName
ORDER BY
    TotalQuantitySold DESC;



/* Business Question #22 - Lowest Selling Products

-- Business Context
Management wants to identify products with low sales
to improve inventory and marketing decisions.

-- Business Question
Which products have sold the lowest total quantity?
*/

-- QUERY

SELECT
    p.ProductID,
    p.ProductName,
    SUM(o.Quantity) AS TotalQuantitySold
FROM Orders o
INNER JOIN Products p
    ON o.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.ProductName
ORDER BY
    TotalQuantitySold ASC;



/* Business Question #23 - Highest Revenue Products

-- Business Context
Management wants to identify products
that generate the highest revenue.

-- Business Question
Which products contribute the highest total revenue?
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



/* Business Question #24 - Product Performance by Category

-- Business Context
Management wants to compare product performance
across different categories.

-- Business Question
How does each product category perform in terms of sales quantity and revenue?
*/

-- QUERY

SELECT
    c.CategoryID,
    c.CategoryName,
    SUM(o.Quantity) AS TotalQuantitySold,
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



/* Business Question #25 - Unsold Products

-- Business Context
Management wants to identify products
that have never been sold.

-- Business Question
Which products have no sales transactions?
*/

-- QUERY

SELECT
    p.ProductID,
    p.ProductName,
    c.CategoryName,
    p.Brand
FROM Products p
LEFT JOIN Orders o
    ON p.ProductID = o.ProductID
INNER JOIN Categories c
    ON p.CategoryID = c.CategoryID
WHERE o.ProductID IS NULL
ORDER BY
    p.ProductName;



/* Business Question #26 - Highest Profit Products

-- Business Context
Management wants to identify products
that generate the highest profit.

-- Business Question
Which products generate the highest total profit?
*/

-- QUERY

SELECT
    p.ProductID,
    p.ProductName,
    SUM(
        (o.UnitPrice - o.UnitCost) * o.Quantity * (1 - o.DiscountPct)
    ) AS TotalProfit
FROM Orders o
INNER JOIN Products p
    ON o.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.ProductName
ORDER BY
    TotalProfit DESC;



/* Business Question #27 - Products with Highest Average Selling Price

-- Business Context
Management wants to analyze
the average selling price of products.

-- Business Question
Which products have the highest average selling price?
*/

-- QUERY

SELECT
    p.ProductID,
    p.ProductName,
    AVG(o.UnitPrice) AS AverageSellingPrice
FROM Orders o
INNER JOIN Products p
    ON o.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.ProductName
ORDER BY
    AverageSellingPrice DESC;



/* Business Question #28 - Products with Highest Discount Given

-- Business Context
Management wants to identify products
that receive the highest discounts.

-- Business Question
Which products have the highest average discount percentage?
*/

-- QUERY

SELECT
    p.ProductID,
    p.ProductName,
    AVG(o.DiscountPct) AS AverageDiscountPct
FROM Orders o
INNER JOIN Products p
    ON o.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.ProductName
ORDER BY
    AverageDiscountPct DESC;



/* Business Question #29 - Product Sales Contribution

-- Business Context
Management wants to understand
each product's contribution to total revenue.

-- Business Question
What percentage of total revenue does each product contribute?
*/

-- QUERY

SELECT
    p.ProductID,
    p.ProductName,
    SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) AS ProductRevenue,
    ROUND(
        SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct))
        * 100.0 /
        SUM(SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct))) OVER (),
        2
    ) AS RevenueContributionPct
FROM Orders o
INNER JOIN Products p
    ON o.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.ProductName
ORDER BY
    RevenueContributionPct DESC;



/* Business Question #30 - Product Revenue Ranking

-- Business Context
Management wants to rank products
based on their revenue contribution.

-- Business Question
How does each product rank by total revenue generated?
*/

-- QUERY

SELECT
    p.ProductID,
    p.ProductName,
    SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) AS TotalRevenue,
    RANK() OVER (
        ORDER BY
            SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) DESC
    ) AS RevenueRank
FROM Orders o
INNER JOIN Products p
    ON o.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.ProductName
ORDER BY
    RevenueRank;
