/*  Motorbike producer database
A company has various business intelligence dashboards to track and analyze its operations and performance across different areas of its business. 
We will consider here the following dashboards: Sales Dashboard, Production Dashboard, Marketing Dashboard, Customer Service Dashboard. 
Created by: PostgreSQL (if you use Oracle SQL you can change datatype Integer to Number and Varchar to Varchar2 to obrain the same results)
*/ 
  
/*TABLE SALES*/ 

 create table sales (  
   VIN            INT,
   vehicle_name   varchar(50) not null,  
   product_family varchar(50),
   no_units_sold  INT,
   price_unit     INT,
   country        varchar(50), 
   order_date     date,
   sale_date      date,
   additional_costs  INT,
   delivery_date     date,  
   dealer_id         INT,
   type_of_contract  varchar(50),
   production_costs INT,
   emp_id         INT,
  constraint pk_sales_dashboard primary key (VIN));

  select * from sales;
 
insert into sales_dashboard values
(1,'Cafe_Racer_Motorradumbau','C_series',1,8900,'United_States','2016-01-01','2022-10-10', 1000,'2023-02-03',500,'leasing',4000,10);
insert into sales values  (2,'Bobber_SE_Concept_Bike_SuperEdition','F_series',2,18950,'France','11-11-2022','10-10-2022', 0,'02-04-2025',501,'leasing',10000,20);
insert into sales values
(3,'BMW_Roadster_Motorrex','G_series',1,17950,'United_States','11-11-2022','10-10-2022', 1000,'02-04-2025',502,'direct_sale',7000,30);
insert into sales values
(4,'BMW_Enduro_SE_Concept','C_series',1,21850,'Italy','07-05-2022','10-10-2022', 1000,'01-04-2028',503,'direct_sale',15000,40);
insert into sales values
(5,'Motorradwippe','F_series',2,12000,'Italy','05-16-2020','10-10-2022',1000,'08-23-2024',504,'credit',3000,50);


/* 1. How much Sales? */
select sum(price_unit) as total_sales from sales;
select sum(production_costs) as costs from salesd;

/* 2. How many vehicles were sold? */
select count(no_units_sold) as items_sold from sales;

/* 3. The average price of a vehicle*/
select avg(price_unit) as average_motorrad_price from sales;

/* 4. How many motorbikes were sold in leasing and how many in credit?*/
select * from sales_dashboard where type_of_contract in ('leasing','credit') order by VIN;

/* 5. What is our profit?*/
select sum(price_unit) - sum(production_costs) as total_profit from sales;

/* 6. Sales growth */
select extract(year from order_date) as year, sum(price_unit) as total_sales from sales group by year order by year;
select extract(year from order_date) as year, sum(price_unit) as total_sales from sales group by year order by year; 
select year1.year as year1,
	   year1.sales as sales1,
	   year2.year as year2,
	   year2.sales as sales2,
	   year2.sales - year1.sales as sales_diff
	   from (select date_part('year', order_date) as year, sum(price_unit) as sales
	   from sales
	   where date_part('year', order_date) = 2020
	   group by date_part('year', order_date)) year1
	   join (select date_part('year', order_date) as year, sum(price_unit) as sales
	   from sales
	   where date_part('year', order_date) = 2022
	   group by date_part('year', order_date)) year2
	   on
	   year1.year < year2.year;

/*7. Min Sales */
select min(price_unit) from sales limit 1;

/*8. Max Sales */
select max(price_unit) from sales limit 1;

/*9. Employee who brought most sales */
select emp_id,sum(price_unit) from sales order by sum(price_unit) DESC;

/*10. All employee who sold 1 vehicle */
select year(sale_date) as year from sales;

/*11. Total cost of ordered vehicles from Jan 2020 till Jan 2022 for a dewaler Woodlands*/
select sum(additional_costs) as total_costs from sales;
select sum(additional_costs) as total_costs from sales where order_date between '01-01-2020' and '01-01-2022';
select dealers.dealer_name,sum(sales.price_unit) as total_costs from dealers as dealers left join sales as sales on dealers.dealer_id=sales.dealer_id where dealers.dealer_id = 504 and order_date between '01-01-2020' and '01-01-2022' group by dealers.dealer_name;


/*12. Total sales by country (2 ways)*/
/*12.1 Partition by - by columns*/
select sale_date, country, price_unit, sum(price_unit) over(partition by country) as total_sales from sales order by country, sale_date; 
/*12.2 Subquery in Select - by countries*/
select sale_date, country,(select sum(price_unit) from sales where country = main.country) from sales as main group by country;

/*13. Percent of sales by country */
select sale_date, country, price_unit, 100.0 * price_unit / sum(price_unit) over (partition by country) as percent_of_sales from sales order by country, sale_date; 


/*TABLE INVENTORY*/ 

create table inventory (  
   VIN            INT,
   vehicle_name   varchar(50) not null,  
   weight         INT,
   price_unit      INT,
   product_family varchar(50),
   no_of_units    INT,
   country       varchar(50),
   dealer_id      INT,
   sale_date   date, 
   runtime    INT,
   no_units_sold  INT,
  primary key(VIN, vehicle_name),
  foreign key(VIN) references sales(VIN) on delete cascade);
      
      insert into inventory values
(1,'Cafe_Racer_Motorradumbau',169,8900,'C_series',60,'United_States',60534,'10-10-2022',5,1);
      insert into inventory values
(2,'Bobber_SE_Concept_Bike_SuperEdition',200,18950,'F_series',1502,'United_States',71623,'10-10-2022',100,1);
      insert into inventory values
(3,'BMW_Roadster_Motorrex',100,17950,'G_series',90,'United_States',43614,'10-10-2022',50,2);
      insert into inventory values
(4,'BMW_Enduro_SE_Concept',150,21850,'C_series',300,'United_States',91834,'10-10-2022',100,1);
      insert into inventory values
(5,'Motorradwippe',177,12000,'F_series',500,'United_States',4614,'10-10-2022',300,2);

       alter table inventory      
      add constraint fk_sales foreign key (VIN) 
      references inventory (vehicle_name) on delete set null;
      
/*1. Inventory level */
select sum(no_of_units) from inventory;

select * from dealers;
   
/*TABLE DEALERS*/ 
create table dealers (  
  dealer_id            INT,  
  dealer_name          varchar(50) not null,  
  dealer_zip           INT,
  VIN                  INT, 
  country              varchar(50),
    constraint pk_dealers primary key (dealer_id));

    alter table dealers      
      add constraint fk_sales foreign key (dealer_id) 
      references dealers (dealer_id) on delete set null;
  
     insert into dealers values
(500,'Grayson',177028,1,'United_States');
insert into dealers values
(501,'Advantage',77489,2,'France');
insert into dealers values
(502,'Momentum',43110,3,'United_States');
insert into dealers values
(503,'Houston_North',31020,4,'Italy');
insert into dealers values
(504,'Woodlands',22313,5,'Italy');

/*Dealers located in the Italy*/
select * from sales_dashboard where country like '%Italy%';

/*How many countries are in the table? */
select count(distinct country) as quantity_countries from dealers;

select * from employees;

/*TABLE EMPLOYEES*/ 
create table employees (  
  emp_id            INT,  
  first_name        varchar(50) not null,  
  last_name         varchar(50),  
  salary            INT,  
  VIN        INT,
  constraint pk_employees primary key (emp_id),  
  constraint fk_employees foreign key (VIN)
      references sales (VIN));
      
insert into employees values
(20,'Jetta','Smyth',57000,1);
insert into employees values
(21,'Fernanda','James',70000,2);
insert into employees values
(22,'Harriet','Mcdaniel',100000,3);
insert into EMPLOYEES values
(23,'Keitha','Müller', 55000,4);
insert into EMPLOYEES values
(24,'Matt','Osborne', 150000,5);
insert into EMPLOYEES values
(25,'Fernanda','James',70000,2);

/*An employee brought the most sales */
select employees.first_name,sum(sales.price_unit) as total_sales
from employees
join sales on employees.vin = sales.vin
group by employees.first_name
order by total_sales DESC
limit 1;

 
