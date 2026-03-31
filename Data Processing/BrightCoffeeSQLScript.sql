---Check if table is loaded correctly and I can read the data---
select * from `workspace`.`default`.`1773680391797_bright_coffee_shop_analysis_case_study_1` limit 100;
---Counting the number of transactions on the dataset---
Select Count(transaction_id) AS Numberoftransaction
from `workspace`.`default`.`1773680391797_bright_coffee_shop_analysis_case_study_1`;
-----------------------------------------------------------------------------------------------
---A. Checking timestamps
Select Min(transaction_time) As Earliest_time
From `workspace`.`default`.`1773680391797_bright_coffee_shop_analysis_case_study_1`;

Select Max(transaction_time) AS Latest_time
From `workspace`.`default`.`1773680391797_bright_coffee_shop_analysis_case_study_1`;

-----------------------------------------------------------------------------------------------
---1. Checking the date range
-----------------------------------------------------------------------------------------------
---Checking the start(2023-01-01) and the end date(2023-06-30)
Select Min(transaction_date) AS Start_date
From `workspace`.`default`.`1773680391797_bright_coffee_shop_analysis_case_study_1`;

Select MAX(transaction_date) as Latest_date
From `workspace`.`default`.`1773680391797_bright_coffee_shop_analysis_case_study_1`;
----------------------------------------------------------------------------------------------
---2. Checking the number of stores and their location (We have 3 store locations)
---------------------------------------------------------------------------------------------
Select distinct Store_location
From `workspace`.`default`.`1773680391797_bright_coffee_shop_analysis_case_study_1`;

---3. Checking the products sold at our stores or shops
Select distinct Product_category
From `workspace`.`default`.`1773680391797_bright_coffee_shop_analysis_case_study_1`;

Select distinct product_detail
From `workspace`.`default`.`1773680391797_bright_coffee_shop_analysis_case_study_1`;


Select distinct product_detail AS product_name,
                product_type,
                product_category AS Category
From `workspace`.`default`.`1773680391797_bright_coffee_shop_analysis_case_study_1`;
------------------------------------------------------------------------------------------------
---4. Checking for NULLS
Select *
From `workspace`.`default`.`1773680391797_bright_coffee_shop_analysis_case_study_1`
Where unit_price is NULL
OR transaction_qty is NULL
OR transaction_date is NULL;
-----------------------------------------------------------------------------------------------
---5. Checking Lowest and Highest Unit_price
Select
      MIN(unit_price) AS Lowest_unit_price,
      MAX(unit_price) AS Highest_unit_price
From `workspace`.`default`.`1773680391797_bright_coffee_shop_analysis_case_study_1`;

------------------------------------------------------------------------------------------------
----6. Counting IDs
Select
    Count(*) AS Number_of_rows,
    COUNT(Distinct transaction_id) AS Number_of_sales,
    Count(Distinct product_id) AS Number_of_product,
    Count(Distinct store_id) AS Number_of_stores
From `workspace`.`default`.`1773680391797_bright_coffee_shop_analysis_case_study_1`;
------------------------------------------------------------------------------------------------
---7. Extracting the day and month name

Select transaction_date, 
       DAYNAME(transaction_date) AS Day_name,
       Monthname(transaction_date) AS Month_name, 
       (transaction_qty*unit_price) AS Revenue 
From `workspace`.`default`.`1773680391797_bright_coffee_shop_analysis_case_study_1`; 
------------------------------------------------------------------------------------------------
Select transaction_date, 
       DAYNAME(transaction_date) AS Day_name,
       Monthname(transaction_date) AS Month_name,
       Dayofmonth(transaction_date) AS Day_of_month, 

       CASE 
           ---When Day_name IN ('Sun','Sat') THEN 'Weekend'
           When Dayname(transaction_date) IN ('Sun','Sat') THEN 'Weekend'
           ELSE 'Weekday'
       END AS Day_Classification,

       ---date_format(transaction_time, 'HH:mm:ss') AS Purchase_time, 
       CASE
           When date_format(transaction_time, 'HH:mm:ss') Between '00:00:00' AND '11:59:59' THEN 'Morning'
           When date_format(transaction_time, 'HH:mm:ss') Between '12:00:00' AND '16:59:59' THEN 'Afternoon'
           When date_format(transaction_time, 'HH:mm:ss') Between '17:00:00' AND '22:00:00' Then 'Evenning'
       END AS Time_buckets, 

---ID Counting 
       Count(Distinct transaction_id) AS Number_of_sales,
       Count(Distinct product_id) AS Number_of_products,
       Count(Distinct store_id) AS Number_of_stores,

---Calculating Revenue
       Sum(transaction_qty*unit_price) AS Revenue_per_day,

       CASE
           When Revenue_per_day <= 100 THEN '01. Low Spend'
           When Revenue_per_day Between 51 and 100 THEN '02. Medium Spend'
           ELSE '03 High Speed'
       END AS Spend_Buckets, 
 
---Categories
       store_location,
       product_category,
       product_detail


From `workspace`.`default`.`1773680391797_bright_coffee_shop_analysis_case_study_1`
Group by transaction_date,
        DAYNAME(transaction_date),
        Monthname(transaction_date),
        Dayofmonth(transaction_date),
        CASE 
           When Dayname(transaction_date) IN ('Sun','Sat') THEN 'Weekend'
           ELSE 'Weekday'
         END,
         CASE
           When date_format(transaction_time, 'HH:mm:ss') Between '00:00:00' AND '11:59:59' THEN 'Morning'
           When date_format(transaction_time, 'HH:mm:ss') Between '12:00:00' AND '16:59:59' THEN 'Afternoon'
           When date_format(transaction_time, 'HH:mm:ss') Between '17:00:00' AND '22:00:00' Then 'Evenning'
         END,
          
         store_location,
         product_category,
         product_detail;
         
         --purchase_time,
       
