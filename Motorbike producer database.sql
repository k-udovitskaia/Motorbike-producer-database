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

 
insert into sales_dashboard values
(1,'Cafe_Racer_Motorradumbau','C_series',1,8900,'United_States','2016-01-01','2022-10-10', 1000,'2023-02-03',500,'leasing',4000,10);
insert into sales values  (2,'Bobber_SE_Concept_Bike_SuperEdition','F_series',2,18950,'France','11-11-2022','10-10-2022', 0,'02-04-2025',501,'leasing',10000,20);
insert into sales values
(3,'BMW_Roadster_Motorrex','G_series',1,17950,'United_States','11-11-2022','10-10-2022', 1000,'02-04-2025',502,'direct_sale',7000,30);
insert into sales values
(4,'BMW_Enduro_SE_Concept','C_series',1,21850,'Italy','07-05-2022','10-10-2022', 1000,'01-04-2028',503,'direct_sale',15000,40);
insert into sales values
(5,'Motorradwippe','F_series',2,12000,'Italy','05-16-2020','10-10-2022',1000,'08-23-2024',504,'credit',3000,50);

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
