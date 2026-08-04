/* Business Question #51 - Return Rate by Product

-- Business Context
Management wants to identify
products with the highest return rates.

-- Business Question
Which products have the highest return rate?
*/

-- QUERY

SELECT
    p.ProductID,
    p.ProductName,
    SUM(r.QuantityReturned) AS TotalReturned,
    SUM(o.Quantity) AS TotalSold,
    ROUND(
        SUM(r.QuantityReturned) * 100.0 /
        SUM(o.Quantity),
        2
    ) AS ReturnRatePct
FROM Orders o
INNER JOIN Returns r
    ON o.OrderID = r.OrderID
INNER JOIN Products p
    ON o.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.ProductName
ORDER BY
    ReturnRatePct DESC;


/* Business Question #52 - Return Rate by Category

-- Business Context
Management wants to compare
return rates across product categories.

-- Business Question
Which product categories have the highest return rate?
*/

-- QUERY

SELECT
    c.CategoryID,
    c.CategoryName,
    SUM(r.QuantityReturned) AS TotalReturned,
    SUM(o.Quantity) AS TotalSold,
    ROUND(
        SUM(r.QuantityReturned) * 100.0 /
        SUM(o.Quantity),
        2
    ) AS ReturnRatePct
FROM Orders o
INNER JOIN Returns r
    ON o.OrderID = r.OrderID
INNER JOIN Products p
    ON o.ProductID = p.ProductID
INNER JOIN Categories c
    ON p.CategoryID = c.CategoryID
GROUP BY
    c.CategoryID,
    c.CategoryName
ORDER BY
    ReturnRatePct DESC;


/* Business Question #53 - Most Common Return Reasons

-- Business Context
Management wants to understand
why customers return products.

-- Business Question
What are the most common return reasons?
*/

-- QUERY

SELECT
    ReturnReason,
    COUNT(*) AS TotalReturns
FROM Returns
GROUP BY
    ReturnReason
ORDER BY
    TotalReturns DESC;


/* Business Question #54 - Customers with Most Returns

-- Business Context
Management wants to identify
customers with frequent product returns.

-- Business Question
Which customers return the most products?
*/

-- QUERY

SELECT
    c.CustomerID,
    c.CustomerName,
    COUNT(r.ReturnID) AS TotalReturns
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
INNER JOIN Returns r
    ON o.OrderID = r.OrderID
GROUP BY
    c.CustomerID,
    c.CustomerName
ORDER BY
    TotalReturns DESC;


/* Business Question #55 - High Revenue but High Return Products

-- Business Context
Management wants to identify
high-revenue products with high return volumes.

-- Business Question
Which products generate high revenue but also have many returns?
*/

-- QUERY

SELECT
    p.ProductID,
    p.ProductName,
    SUM(o.Quantity * o.UnitPrice * (1 - o.DiscountPct)) AS TotalRevenue,
    SUM(r.QuantityReturned) AS TotalReturned
FROM Orders o
INNER JOIN Returns r
    ON o.OrderID = r.OrderID
INNER JOIN Products p
    ON o.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.ProductName
ORDER BY
    TotalRevenue DESC,
    TotalReturned DESC;


/* Business Question #56 - Employees with Highest Return Rate

-- Business Context
Management wants to evaluate
employees whose sales result in frequent returns.

-- Business Question
Which employees have the highest return rate?
*/

-- QUERY

SELECT
    e.EmployeeID,
    e.EmployeeName,
    SUM(r.QuantityReturned) AS TotalReturned,
    SUM(o.Quantity) AS TotalSold,
    ROUND(
        SUM(r.QuantityReturned) * 100.0 /
        SUM(o.Quantity),
        2
    ) AS ReturnRatePct
FROM Employees e
INNER JOIN Orders o
    ON e.EmployeeID = o.EmployeeID
INNER JOIN Returns r
    ON o.OrderID = r.OrderID
GROUP BY
    e.EmployeeID,
    e.EmployeeName
ORDER BY
    ReturnRatePct DESC;


/* Business Question #57 - Monthly Return Trend

-- Business Context
Management wants to monitor
return trends over time.

-- Business Question
How many products are returned each month?
*/

-- QUERY

SELECT
    YEAR(ReturnDate) AS ReturnYear,
    MONTH(ReturnDate) AS ReturnMonth,
    COUNT(ReturnID) AS TotalReturns
FROM Returns
GROUP BY
    YEAR(ReturnDate),
    MONTH(ReturnDate)
ORDER BY
    ReturnYear,
    ReturnMonth;


/* Business Question #58 - Return Value by Category

-- Business Context
Management wants to estimate
the financial impact of returned products.

-- Business Question
What is the return value for each category?
*/

-- QUERY

SELECT
    c.CategoryID,
    c.CategoryName,
    SUM(r.QuantityReturned * o.UnitPrice) AS ReturnValue
FROM Returns r
INNER JOIN Orders o
    ON r.OrderID = o.OrderID
INNER JOIN Products p
    ON o.ProductID = p.ProductID
INNER JOIN Categories c
    ON p.CategoryID = c.CategoryID
GROUP BY
    c.CategoryID,
    c.CategoryName
ORDER BY
    ReturnValue DESC;


/* Business Question #59 - Products Never Returned

-- Business Context
Management wants to identify
products with excellent quality.

-- Business Question
Which products have never been returned?
*/

-- QUERY

SELECT
    p.ProductID,
    p.ProductName
FROM Products p
LEFT JOIN Orders o
    ON p.ProductID = o.ProductID
LEFT JOIN Returns r
    ON o.OrderID = r.OrderID
WHERE
    r.ReturnID IS NULL
ORDER BY
    p.ProductName;


/* Business Question #60 - Return Percentage by Customer Segment

-- Business Context
Management wants to compare
return behavior across customer segments.

-- Business Question
Which customer segments have the highest return percentage?
*/

-- QUERY

SELECT
    c.CustomerSegment,
    SUM(r.QuantityReturned) AS TotalReturned,
    SUM(o.Quantity) AS TotalSold,
    ROUND(
        SUM(r.QuantityReturned) * 100.0 /
        SUM(o.Quantity),
        2
    ) AS ReturnRatePct
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
INNER JOIN Returns r
    ON o.OrderID = r.OrderID
GROUP BY
    c.CustomerSegment
ORDER BY
    ReturnRatePct DESC;
