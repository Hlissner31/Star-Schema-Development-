#Strategic:
#Total revenue per month for April, May, and June in 2005.
SELECT 
    MONTH(Date) AS Month,
    YEAR(Date) AS Year,
    SUM(Revenue) AS Total_Revenue
FROM 
    fact_sales
WHERE 
    YEAR(Date) = 2005 AND MONTH(Date) IN (4, 5, 6)
GROUP BY 
    MONTH(Date), YEAR(Date);
#Total purchase count per month for April, May, and June in 2005.
SELECT 
    MONTH(Date) AS Month,
    YEAR(Date) AS Year,
    COUNT(*) AS Total_Purchase_Count
FROM 
    fact_sales
WHERE 
    YEAR(Date) = 2005 AND MONTH(Date) IN (4, 5, 6)
GROUP BY 
    MONTH(Date), YEAR(Date);
#Total profit per year and percentage profit for each month in 2004 and 2005.
#################################################
-- Query for 2004
SELECT 
    YEAR(fs.`Date`) AS Year,
    MONTHNAME(fs.`Date`) AS Month,
    SUM(fs.Revenue - fr.Revenue_Returned) AS Total_Profit,
    (SUM(fs.Revenue - fr.Revenue_Returned) / (SELECT SUM(fs.Revenue - fr.Revenue_Returned) FROM fact_sales fs WHERE YEAR(fs.`Date`) = 2004)) * 100 AS Percentage_Profit
FROM 
    fact_sales fs
LEFT JOIN 
    fact_returns fr ON fs.`Date` = fr.`Date` AND fs.SKU = fr.SKU AND fs.store_id = fr.store_id
WHERE 
    YEAR(fs.`Date`) = 2004
GROUP BY 
    YEAR(fs.`Date`), MONTH(fs.`Date`);

-- Query for 2005
SELECT 
    YEAR(fs.`Date`) AS Year,
    MONTHNAME(fs.`Date`) AS Month,
    SUM(fs.Revenue - fr.Revenue_Returned) AS Total_Profit,
    (SUM(fs.Revenue - fr.Revenue_Returned) / (SELECT SUM(fs.Revenue - fr.Revenue_Returned) FROM fact_sales fs WHERE YEAR(fs.`Date`) = 2005)) * 100 AS Percentage_Profit
FROM 
    fact_sales fs
LEFT JOIN 
    fact_returns fr ON fs.`Date` = fr.`Date` AND fs.SKU = fr.SKU AND fs.store_id = fr.store_id
WHERE 
    YEAR(fs.`Date`) = 2005
GROUP BY 
    YEAR(fs.`Date`), MONTH(fs.`Date`);

#Top 5 brands that are returned most frequently and the associated lost revenue.

SELECT 
    SKU,
    SUM(Quantity_Returned) AS Returned_Quantity,
    SUM(Revenue_Returned) AS Lost_Revenue
FROM 
    fact_returns
GROUP BY 
    SKU
ORDER BY 
    Returned_Quantity DESC
LIMIT 5;
#Analytical:
#Top 10 SKUs based on quantity sold for May 7, 2005 to May 14, 2005.

SELECT 
    SKU,
    SUM(Quantity_Sold) AS Total_Quantity_Sold
FROM 
    fact_sales
WHERE 
    Date BETWEEN '2005-05-07' AND '2005-05-14'
GROUP BY 
    SKU
ORDER BY 
    Total_Quantity_Sold DESC
LIMIT 10;
#Top 3 department and city combinations based on revenue for December 1, 2004 to December 31, 2004.
########################################
SELECT 
    dsk.Right_deptdesc as Department,
    ds.City,
    SUM(fs.Revenue) AS Total_Revenue
FROM 
    dim_store ds
JOIN 
    fact_sales fs ON ds.store_id = fs.store_id
join dim_sku dsk
	on fs.SKU = dsk.SKU
WHERE 
    fs.Date BETWEEN '2004-12-01' AND '2004-12-31'
GROUP BY 
    dsk.Right_deptdesc, ds.City
ORDER BY 
    Total_Revenue DESC
LIMIT 3;

#The number of returned items for each day of the week for June 2005.

SELECT 
    DAYNAME(r.Date) AS Day_of_Week,
    SUM(r.Quantity_Returned) AS Returned_Items_Total
FROM 
    fact_returns r
WHERE 
    YEAR(r.Date) = 2005 AND MONTH(r.Date) = 6
GROUP BY 
    DAYOFWEEK(r.Date)
ORDER BY 
    DAYOFWEEK(r.Date);
#The sales trend for each month in 2005.

SELECT 
    MONTH(Date) AS Month,
    SUM(Revenue) AS Total_Revenue
FROM 
    fact_sales
WHERE 
    YEAR(Date) = 2005
GROUP BY 
    MONTH(Date)
ORDER BY 
    MONTH(Date);
#Operational:
#Average revenue per transaction from April 1, 2005 to April 30, 2005 for stores in Texas.

SELECT 
    Date,
    (SUM(Revenue) / SUM(Transaction_Count)) AS Average_Revenue_Per_Transaction
FROM 
    fact_sales
JOIN 
    dim_store ON fact_sales.Store_id = dim_store.store_id
WHERE 
    dim_store.State = 'Texas'
    AND Date BETWEEN '2005-04-01' AND '2005-04-30'
GROUP BY 
    Date;
#Daily purchase count for a given department from April 7, 2005 to April 14, 2005.
#########################################
SELECT 
    fs.Date,
    COUNT(*) AS Purchase_Count
FROM 
    fact_sales fs
join dim_sku ds
	on ds.SKU = fs.SKU
WHERE 
    ds.dept_id = 2301
    AND Date BETWEEN '2005-04-07' AND '2005-04-14'
GROUP BY 
    Date;
#The 5 lowest performing stores for April 1, 2005 to April 30, 2005 based on purchase revenue.

SELECT 
    Store_id,
    SUM(Revenue) AS Total_Revenue
FROM 
    fact_sales
WHERE 
    Date BETWEEN '2005-04-01' AND '2005-04-30'
GROUP BY 
    Store_id
ORDER BY 
    Total_Revenue
LIMIT 5;

