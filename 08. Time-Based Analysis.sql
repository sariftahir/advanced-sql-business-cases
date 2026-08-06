/* Business Question #71 - Monthly Revenue Trend

-- Business Context
Management wants to monitor
monthly revenue performance over time.

-- Business Question
How does revenue change every month?
*/

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


/* Business Question #72 - Quarterly Sales Trend

-- Business Context
Management wants to analyze
sales performance by quarter.

-- Business Question
How much revenue is generated each quarter?
*/

-- QUERY

SELECT
    YEAR(OrderDate) AS SalesYear,
    DATEPART(QUARTER, OrderDate) AS SalesQuarter,
    SUM(Quantity * UnitPrice * (1 - DiscountPct)) AS TotalRevenue
FROM Orders
GROUP BY
    YEAR(OrderDate),
    DATEPART(QUARTER, OrderDate)
ORDER BY
    SalesYear,
    SalesQuarter;


/* Business Question #73 - Yearly Revenue Comparison

-- Business Context
Management wants to compare
annual revenue performance.

-- Business Question
How much revenue is generated each year?
*/

-- QUERY

SELECT
    YEAR(OrderDate) AS SalesYear,
    SUM(Quantity * UnitPrice * (1 - DiscountPct)) AS TotalRevenue
FROM Orders
GROUP BY
    YEAR(OrderDate)
ORDER BY
    SalesYear;


/* Business Question #74 - Weekend vs Weekday Sales

-- Business Context
Management wants to compare
sales performance between weekdays and weekends.

-- Business Question
How much revenue is generated on weekdays versus weekends?
*/

-- QUERY

SELECT
    CASE
        WHEN DATENAME(WEEKDAY, OrderDate) IN ('Saturday','Sunday')
            THEN 'Weekend'
        ELSE 'Weekday'
    END AS DayType,
    SUM(Quantity * UnitPrice * (1 - DiscountPct)) AS TotalRevenue
FROM Orders
GROUP BY
    CASE
        WHEN DATENAME(WEEKDAY, OrderDate) IN ('Saturday','Sunday')
            THEN 'Weekend'
        ELSE 'Weekday'
    END;


/* Business Question #75 - Peak Sales Month

-- Business Context
Management wants to identify
the strongest sales month.

-- Business Question
Which month generates the highest revenue?
*/

-- QUERY

SELECT TOP 1
    YEAR(OrderDate) AS SalesYear,
    MONTH(OrderDate) AS SalesMonth,
    SUM(Quantity * UnitPrice * (1 - DiscountPct)) AS TotalRevenue
FROM Orders
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    TotalRevenue DESC;


/* Business Question #76 - Peak Sales Quarter

-- Business Context
Management wants to identify
the highest-performing sales quarter.

-- Business Question
Which quarter generates the highest revenue?
*/

-- QUERY

SELECT TOP 1
    YEAR(OrderDate) AS SalesYear,
    DATEPART(QUARTER, OrderDate) AS SalesQuarter,
    SUM(Quantity * UnitPrice * (1 - DiscountPct)) AS TotalRevenue
FROM Orders
GROUP BY
    YEAR(OrderDate),
    DATEPART(QUARTER, OrderDate)
ORDER BY
    TotalRevenue DESC;


/* Business Question #77 - Monthly Order Growth

-- Business Context
Management wants to monitor
changes in order volume over time.

-- Business Question
How does the number of orders grow month-over-month?
*/

-- QUERY

WITH MonthlyOrders AS
(
    SELECT
        YEAR(OrderDate) AS SalesYear,
        MONTH(OrderDate) AS SalesMonth,
        COUNT(DISTINCT OrderID) AS TotalOrders
    FROM Orders
    GROUP BY
        YEAR(OrderDate),
        MONTH(OrderDate)
)

SELECT
    SalesYear,
    SalesMonth,
    TotalOrders,
    LAG(TotalOrders) OVER
    (
        ORDER BY
            SalesYear,
            SalesMonth
    ) AS PreviousMonthOrders,
    TotalOrders
        - LAG(TotalOrders) OVER
        (
            ORDER BY
                SalesYear,
                SalesMonth
        ) AS OrderGrowth
FROM MonthlyOrders
ORDER BY
    SalesYear,
    SalesMonth;


/* Business Question #78 - Revenue by Day of Week

-- Business Context
Management wants to identify
which weekdays generate the most revenue.

-- Business Question
How much revenue is generated on each day of the week?
*/

-- QUERY

SELECT
    DATENAME(WEEKDAY, OrderDate) AS DayName,
    SUM(Quantity * UnitPrice * (1 - DiscountPct)) AS TotalRevenue
FROM Orders
GROUP BY
    DATENAME(WEEKDAY, OrderDate)
ORDER BY
    TotalRevenue DESC;


/* Business Question #79 - Seasonality Analysis

-- Business Context
Management wants to identify
seasonal sales patterns.

-- Business Question
Which month consistently generates the highest revenue?
*/

-- QUERY

SELECT
    MONTH(OrderDate) AS SalesMonth,
    DATENAME(MONTH, OrderDate) AS MonthName,
    SUM(Quantity * UnitPrice * (1 - DiscountPct)) AS TotalRevenue
FROM Orders
GROUP BY
    MONTH(OrderDate),
    DATENAME(MONTH, OrderDate)
ORDER BY
    SalesMonth;


/* Business Question #80 - Year-over-Year (YoY) Revenue Growth

-- Business Context
Management wants to evaluate
annual business growth.

-- Business Question
How much does revenue grow year-over-year?
*/

-- QUERY

WITH YearlyRevenue AS
(
    SELECT
        YEAR(OrderDate) AS SalesYear,
        SUM(Quantity * UnitPrice * (1 - DiscountPct)) AS TotalRevenue
    FROM Orders
    GROUP BY
        YEAR(OrderDate)
)

SELECT
    SalesYear,
    TotalRevenue,
    LAG(TotalRevenue) OVER
    (
        ORDER BY SalesYear
    ) AS PreviousYearRevenue,
    TotalRevenue
        - LAG(TotalRevenue) OVER
        (
            ORDER BY SalesYear
        ) AS RevenueGrowth
FROM YearlyRevenue
ORDER BY
    SalesYear;
