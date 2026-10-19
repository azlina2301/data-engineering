

drop table if exists dim_products;

create table dim_products as
select distinct 
	row_number() over (order by productcode) as product_key,
	productcode as product_code,
	initcap(productline) as product_line,
	msrp as list_price
from sales_data;


select * from dim_products;


-- Customer dimensional --

create table dim_customer as 
select distinct
	row_number() over (order by customername) as customer_key,
	trim(customername) as customer_name,
	trim(city) as city,
	trim(country) as country,
	coalesce(territory, 'Unknown') as territory
from sales_data;

select * from dim_customer;


-- Time Dimension

create table dim_time as 
select distinct
	year_id * 100 + month_id as time_key,
	year_id,
	month_id,
	qtr_id as quarter,
	case
		when month_id in (1, 2, 3) then 'Q1'
		when month_id in (4, 5, 6) then 'Q2'
		when month_id in (7, 8, 9) then 'Q3'
	else 'Q4' 
	end as quarter_name,
	case
		when month_id in (10, 11, 12) then 'Holiday Season'
		when month_id in (6, 7, 8) then 'Summer'
		else 'Regular'
	end as Season
from sales_data;


select * from dim_time;

--fact table
create table fact_sales as 
select
	ordernumber as order_number,
	orderlinenumber as line_number,
	(select customer_key from dim_customer dc 
	where dc.customer_name = trim(sd.customername) limit 1) as customer_key,
	(select product_key from dim_products dp
	where dp.product_code = sd.productcode limit 1) as product_key,
	sd.year_id * 100 + sd.month_id as time_key,
	quantityordered as quntity,
	priceeach as unit_price,
	sales as line_total,
	case 
		when status = 'Shipped' then 'Completed'
		when status = 'Resolved' then 'Completed'
		else status
	end as order_status
from sales_data sd;


select * from fact_sales limit 10;



-- View 1 - Monthly sales summary

create or replace view v_monthly_sale as
select 
	t.year_id,
	t.month_id,
	t.quarter_name,
	t.season,
	sum(f.line_total) as total_sales,
	sum(f.quntity) as units_sold,
	count(distinct f.order_number) as order_count
from fact_sales f
join dim_time t on t.time_key = t.time_key
group by t.year_id, t.month_id, t.quarter_name, t.season
order by t.year_id, t.month_id;


select * from v_monthly_sale;

-- View 2 - Product performance
CREATE OR REPLACE VIEW v_product_performance AS 
SELECT 
	p.product_line,
	sum(f.line_total) AS revenue,
	sum(f.quntity) AS units_sold,
	round(avg(f.unit_price), 2) AS avg_price,
	count(DISTINCT f.order_number) AS orders
FROM fact_sales f
JOIN dim_products p ON f.product_key = p.product_key
GROUP BY p.product_line
ORDER BY revenue DESC;
	
	
select * from v_product_performance;


-- View 3: - Customer summary
create or replace view v_customer_summary as
select
	c.customer_name,
	c.country,
	c.territory,
	sum(f.line_total) as total_spent,
	count(distinct f.order_number) as order_count
from fact_sales f
join dim_customer c on f.customer_key = c.customer_key
group by c.customer_key, c.customer_name, c.country, c.territory
order by total_spent desc;


select * from v_customer_summary limit 10;