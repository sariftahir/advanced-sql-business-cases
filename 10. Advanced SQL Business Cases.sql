/* Business Question #91 - Customer Retention Analysis

-- Business Context
Management wants to identify
customers who repeatedly purchase over time.

-- Business Question
Which customers have made purchases
in multiple different months?
*/

-- QUERY

SELECT
    c.CustomerID,
    c.CustomerName,
    COUNT(DISTINCT
        YEAR(o.OrderDate) * 100 +
        MONTH(o.OrderDate)
    ) AS ActiveMonths,
    SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) AS TotalRevenue
FROM Orders o
INNER JOIN Customers c
    ON o.CustomerID = c.CustomerID
GROUP BY
    c.CustomerID,
    c.CustomerName
HAVING COUNT(DISTINCT
        YEAR(o.OrderDate) * 100 +
        MONTH(o.OrderDate)
    ) >= 3
ORDER BY
    ActiveMonths DESC,
    TotalRevenue DESC;


/* Business Question #92 - Running Total Revenue

-- Business Context
Management wants to monitor
cumulative revenue growth over time.

-- Business Question
What is the cumulative revenue by order date?
*/

-- QUERY

SELECT
    OrderDate,
    SUM(Quantity * UnitPrice * (1 - DiscountPct)) AS DailyRevenue,
    SUM(
        SUM(Quantity * UnitPrice * (1 - DiscountPct))
    ) OVER
    (
        ORDER BY OrderDate
    ) AS RunningRevenue
FROM Orders
GROUP BY
    OrderDate
ORDER BY
    OrderDate;


/* Business Question #93 - Rolling 3-Month Sales

-- Business Context
Management wants to smooth
monthly sales fluctuations.

-- Business Question
What is the rolling 3-month revenue?
*/

-- QUERY

WITH MonthlySales AS
(
    SELECT
        YEAR(OrderDate) AS SalesYear,
        MONTH(OrderDate) AS SalesMonth,
        SUM(Quantity * UnitPrice * (1 - DiscountPct)) AS MonthlyRevenue
    FROM Orders
    GROUP BY
        YEAR(OrderDate),
        MONTH(OrderDate)
)

SELECT
    SalesYear,
    SalesMonth,
    MonthlyRevenue,
    SUM(MonthlyRevenue) OVER
    (
        ORDER BY
            SalesYear,
            SalesMonth
        ROWS BETWEEN 2 PRECEDING
        AND CURRENT ROW
    ) AS Rolling3MonthRevenue
FROM MonthlySales
ORDER BY
    SalesYear,
    SalesMonth;


/* Business Question #94 - Top Product in Every Category

-- Business Context
Management wants to identify
the best-performing product
within each category.

-- Business Question
Which product generates
the highest revenue in each category?
*/

-- QUERY

WITH ProductRevenue AS
(
    SELECT
        ca.CategoryName,
        p.ProductID,
        p.ProductName,
        SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) AS TotalRevenue,
        ROW_NUMBER() OVER
        (
            PARTITION BY ca.CategoryID
            ORDER BY
                SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) DESC
        ) AS RowNum
    FROM Orders o
    INNER JOIN Products p
        ON o.ProductID = p.ProductID
    INNER JOIN Categories ca
        ON p.CategoryID = ca.CategoryID
    GROUP BY
        ca.CategoryID,
        ca.CategoryName,
        p.ProductID,
        p.ProductName
)

SELECT
    CategoryName,
    ProductID,
    ProductName,
    TotalRevenue
FROM ProductRevenue
WHERE RowNum = 1;


/* Business Question #95 - Customer Purchase Ranking

-- Business Context
Management wants to rank
customers based on revenue.

-- Business Question
How does each customer rank
by total revenue?
*/

-- QUERY

SELECT
    c.CustomerID,
    c.CustomerName,
    SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) AS TotalRevenue,
    DENSE_RANK() OVER
    (
        ORDER BY
            SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) DESC
    ) AS RevenueRank
FROM Orders o
INNER JOIN Customers c
    ON o.CustomerID = c.CustomerID
GROUP BY
    c.CustomerID,
    c.CustomerName;


/* Business Question #96 - Revenue Growth (MoM)

-- Business Context
Management wants to evaluate
month-over-month revenue growth.

-- Business Question
How does revenue change
compared to the previous month?
*/

-- QUERY

WITH MonthlyRevenue AS
(
    SELECT
        YEAR(OrderDate) AS SalesYear,
        MONTH(OrderDate) AS SalesMonth,
        SUM(Quantity * UnitPrice * (1 - DiscountPct)) AS Revenue
    FROM Orders
    GROUP BY
        YEAR(OrderDate),
        MONTH(OrderDate)
)

SELECT
    *,
    Revenue
        - LAG(Revenue)
        OVER(
            ORDER BY
                SalesYear,
                SalesMonth
        ) AS RevenueGrowth
FROM MonthlyRevenue;


/* Business Question #97 - Revenue Growth (YoY)

-- Business Context
Management wants to compare
annual business performance.

-- Business Question
How does yearly revenue
change compared to the previous year?
*/

-- QUERY

WITH YearlyRevenue AS
(
    SELECT
        YEAR(OrderDate) AS SalesYear,
        SUM(Quantity * UnitPrice * (1 - DiscountPct)) AS Revenue
    FROM Orders
    GROUP BY
        YEAR(OrderDate)
)

SELECT
    *,
    Revenue
        - LAG(Revenue)
        OVER(
            ORDER BY SalesYear
        ) AS RevenueGrowth
FROM YearlyRevenue;


/* Business Question #98 - RFM Analysis

-- Business Context
Management wants to segment
customers based on purchasing behavior.

-- Business Question
What are each customer's
Recency, Frequency, and Monetary values?
*/

-- QUERY

SELECT
    c.CustomerID,
    c.CustomerName,
    MAX(o.OrderDate) AS LastPurchaseDate,
    DATEDIFF(
        DAY,
        MAX(o.OrderDate),
        GETDATE()
    ) AS Recency,
    COUNT(DISTINCT o.OrderID) AS Frequency,
    SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) AS Monetary
FROM Orders o
INNER JOIN Customers c
    ON o.CustomerID = c.CustomerID
GROUP BY
    c.CustomerID,
    c.CustomerName;


/* Business Question #99 - Window Function Ranking

-- Business Context
Management wants to compare
multiple ranking methods.

-- Business Question
How do RANK, DENSE_RANK,
and ROW_NUMBER differ?
*/

-- QUERY

SELECT
    p.ProductID,
    p.ProductName,
    SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) AS Revenue,

    ROW_NUMBER() OVER
    (
        ORDER BY
            SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) DESC
    ) AS RowNumber,

    RANK() OVER
    (
        ORDER BY
            SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) DESC
    ) AS RankNumber,

    DENSE_RANK() OVER
    (
        ORDER BY
            SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) DESC
    ) AS DenseRank

FROM Orders o
INNER JOIN Products p
    ON o.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.ProductName;


/* Business Question #100 - Multi-CTE Executive Report

-- Business Context
Executives require a single report
combining key business metrics.

-- Business Question
What is the consolidated executive
performance report?
*/

-- QUERY

WITH RevenueSummary AS
(
    SELECT
        SUM(Quantity * UnitPrice * (1 - DiscountPct)) AS TotalRevenue,
        SUM((UnitPrice - UnitCost) * Quantity * (1 - DiscountPct)) AS TotalProfit
    FROM Orders
),
OrderSummary AS
(
    SELECT
        COUNT(DISTINCT OrderID) AS TotalOrders,
        COUNT(DISTINCT CustomerID) AS TotalCustomers
    FROM Orders
),
ReturnSummary AS
(
    SELECT
        COUNT(*) AS TotalReturns
    FROM Returns
)

SELECT
    r.TotalRevenue,
    r.TotalProfit,
    o.TotalOrders,
    o.TotalCustomers,
    rs.TotalReturns
FROM RevenueSummary r
CROSS JOIN OrderSummary o
CROSS JOIN ReturnSummary rs;
