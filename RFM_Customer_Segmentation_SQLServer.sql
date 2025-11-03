/*

 Title: RFM Customer Segmentation in SQL Server
 Author: Sherif Khaled
 Description:
   This SQL script performs RFM (Recency, Frequency, Monetary) 
   analysis to segment customers based on their purchasing behavior.
 Features:
   - Calculates recency in days using DATEDIFF
   - Uses NTILE() to rank customers into 5 RFM groups
   - Assigns descriptive customer segments (Champions, Loyal, Lost, etc.)
   - Compatible with Microsoft SQL Server

*/

---------------------------------------------------------------------

/* # of Csutomer, # of Orders , and AVG paid price per Country */

select distinct country	as Country, 
	   count(distinct invoice) as 'Number_Of_Orders',
	   count(distinct customer_id) as 'Number_Of_Customer',
	   avg(price * quantity) as 'AVG_Payment'
from tableRetail
group by Country
order by Number_Of_Orders

---------------------------------------------------------------------

/* # of Orders per date */

select distinct InvoiceDate	as 'Date',
	   count(invoice) as 'Number_Of_Orders'
from tableRetail
group by InvoiceDate
order by Number_Of_Orders desc

---------------------------------------------------------------------

/* # of Quantites per date */

select distinct InvoiceDate	as 'Date',
	   sum(Quantity) as 'Total_Quantites'
from tableRetail
group by InvoiceDate
order by Total_Quantites desc

---------------------------------------------------------------------

/* Highest Revenue made throughout the day */

select distinct InvoiceDate	as 'Date',
	   sum(Quantity * Price) as 'Revenue'
from tableRetail
group by InvoiceDate
order by Revenue desc

---------------------------------------------------------------------

/* Highest paid Customers per interval */

select distinct Customer_ID	as 'Customer_ID',
	   InvoiceDate as 'Date',
	   sum (Price * Quantity) as 'Total_Price'
from tableRetail
group by Customer_ID, InvoiceDate
order by Total_Price desc

---------------------------------------------------------------------

/* RFM Segmentation query */

with rfm_base as(
	select 
		Customer_ID,
		max(cast(InvoiceDate as datetime)) as 'Last_Order_Date',
		count(distinct Invoice) as 'Order_Count',
		sum(Price * Quantity) as 'Total_Price'
	from tableRetail
	group by Customer_ID
),

rfm as(
	select
		Customer_ID,
		DATEDIFF(DAY, max(Last_Order_Date), GETDATE()) as 'Recency',
		Order_Count,
		Total_Price
	from rfm_base
	group by Customer_ID, Order_Count, Total_Price
),

customer_segemnt_score as(
	select 
		Customer_ID,
		NTILE(5) over (order by Recency asc) as 'Recency_Score',
		NTILE(5) over (order by Order_Count desc) as 'Frequency_Score',
		NTILE(5) over (order by Total_Price desc) as 'Monetary_Score'
	from rfm
)

select Customer_ID,
	   Recency_Score,
	   Frequency_Score,
	   Monetary_Score,
	   (Recency_Score + Frequency_Score + Monetary_Score) as 'Total_Score',
	   case
	      when (Recency_Score + Frequency_Score + Monetary_Score) = 15 then 'Champions'
		  when (Recency_Score + Frequency_Score + Monetary_Score) >= 12 then 'Loyal Customers'
		  when (Recency_Score + Frequency_Score + Monetary_Score) between 9 and 11 then 'Potential Loyalists'
		  when (Recency_Score + Frequency_Score + Monetary_Score) between 6 and 8 then 'Customers Needing Attention'
		  when (Recency_Score + Frequency_Score + Monetary_Score) between 4 and 5 then 'Hibernating'
		  when (Recency_Score + Frequency_Score + Monetary_Score) <= 3 then 'Lost'
	   end as 'Customer_Segemnt'
from customer_segemnt_score
order by Total_Score desc, Frequency_Score desc, Monetary_Score desc