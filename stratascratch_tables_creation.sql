-- Highest energy consumption
create table fb_eu_energy
(
    date        date not null,
    consumption int  not null
);
create table fb_asia_energy
(
    date        date not null,
    consumption int  not null
);
create table fb_na_energy
(
    date        date not null,
    consumption int  not null
);
INSERT INTO fb_eu_energy VALUES
('2020-01-01', 400),
('2020-01-02', 350),
('2020-01-03', 500),
('2020-01-04', 500),
('2020-01-07', 600);
INSERT INTO fb_asia_energy VALUES
('2020-01-01',400),
('2020-01-02',400),
('2020-01-04',675),
('2020-01-05',1200),
('2020-01-06',750),
('2020-01-07',400);
INSERT INTO fb_na_energy VALUES
('2020-01-01',250),
('2020-01-02',375),
('2020-01-03',600),
('2020-01-06',500),
('2020-01-07',250);

-- Finding User Purchases
create table amazon_transactions
(
    id        int not null,
    user_id int  not null,
    item varchar not null,
    created_at date not null,
    revenue int not null
);
INSERT INTO amazon_transactions VALUES
(1,109,'milk','2020-03-03',123),
(2,139,'biscuit','2020-03-18',421),
(3,120,'milk','2020-03-18',176),
(4,108,'banana','2020-03-18',862),
(5,130,'milk','2020-03-28',333),
(6,103,'bread','2020-03-29',862),
(7,122,'banana','2020-03-07',952),
(8,125,'bread','2020-03-13',317),
(9,139,'bread','2020-03-30',929),
(10,141,'banana','2020-03-17',812),
(11,116,'bread','2020-03-31',226),
(12,128,'bread','2020-03-04',112),
(13,146,'biscuit','2020-03-04',362),
(14,119,'banana','2020-03-28',127),
(15,142,'bread','2020-03-09',503),
(16,122,'bread','2020-03-06',593),
(17,128,'biscuit','2020-03-24',160),
(18,112,'banana','2020-03-24',262),
(19,149,'banana','2020-03-29',382),
(20,100,'banana','2020-03-18',599),
(21,130,'milk','2020-03-16',604),
(22,103,'milk','2020-03-31',290),
(23,112,'banana','2020-03-23',523),
(24,102,'bread','2020-03-25',325),
(25,120,'biscuit','2020-03-21',858),
(26,109,'bread','2020-03-22',432),
(27,101,'milk','2020-03-01',449),
(28,138,'milk','2020-03-19',961),
(29,100,'milk','2020-03-29',410),
(30,129,'milk','2020-03-02',771),
(31,123,'milk','2020-03-31',434),
(32,104,'biscuit','2020-03-31',957),
(33,110,'bread','2020-03-13',210),
(34,143,'bread','2020-03-27',870),
(35,130,'milk','2020-03-12',176),
(36,128,'milk','2020-03-28',498),
(37,133,'banana','2020-03-21',837),
(38,150,'banana','2020-03-20',927),
(39,120,'milk','2020-03-27',793),
(40,109,'bread','2020-03-02',362),
(41,110,'bread','2020-03-13',262),
(42,140,'milk','2020-03-09',468),
(43,112,'banana','2020-03-04',381),
(44,117,'biscuit','2020-03-19',831),
(45,137,'banana','2020-03-23',490),
(46,130,'bread','2020-03-09',149),
(47,133,'bread','2020-03-08',658),
(48,143,'milk','2020-03-11',317),
(49,111,'biscuit','2020-03-23',204),
(50,150,'banana','2020-03-04',299),
(51,131,'bread','2020-03-10',155),
(52,140,'biscuit','2020-03-17',810),
(53,147,'banana','2020-03-22',702),
(54,119,'biscuit','2020-03-15',355),
(55,116,'milk','2020-03-12',468),
(56,141,'milk','2020-03-14',254),
(57,143,'bread','2020-03-16',647),
(58,105,'bread','2020-03-21',562),
(59,149,'biscuit','2020-03-11',827),
(60,117,'banana','2020-03-22',249),
(61,150,'banana','2020-03-21',450),
(62,134,'bread','2020-03-08',981),
(63,133,'banana','2020-03-26',353),
(64,127,'milk','2020-03-27',300),
(65,101,'milk','2020-03-26',740),
(66,137,'biscuit','2020-03-12',473),
(67,113,'biscuit','2020-03-21',278),
(68,141,'bread','2020-03-21',118),
(69,112,'biscuit','2020-03-14',334),
(70,118,'milk','2020-03-30',603),
(71,111,'milk','2020-03-19',205),
(72,146,'biscuit','2020-03-13',599),
(73,148,'banana','2020-03-14',530),
(74,100,'banana','2020-03-13',175),
(75,105,'banana','2020-03-05',815),
(76,129,'milk','2020-03-02',489),
(77,121,'milk','2020-03-16',476),
(78,117,'bread','2020-03-11',270),
(79,133,'milk','2020-03-12',446),
(80,124,'bread','2020-03-31',937),
(81,145,'bread','2020-03-07',821),
(82,105,'banana','2020-03-09',972),
(83,131,'milk','2020-03-09',808),
(84,114,'biscuit','2020-03-31',202),
(85,120,'milk','2020-03-06',898),
(86,130,'milk','2020-03-06',581),
(87,141,'biscuit','2020-03-11',749),
(88,147,'bread','2020-03-14',262),
(89,118,'milk','2020-03-15',735),
(90,136,'biscuit','2020-03-22',410),
(91,132,'bread','2020-03-06',161),
(92,137,'biscuit','2020-03-31',427),
(93,107,'bread','2020-03-01',701),
(94,111,'biscuit','2020-03-18',218),
(95,100,'bread','2020-03-07',410),
(96,106,'milk','2020-03-21',379),
(97,114,'banana','2020-03-25',705),
(98,110,'bread','2020-03-27',225),
(99,130,'milk','2020-03-16',494),
(100,117,'bread','2020-03-10',209);


-- Users By Avg Session time
create table facebook_web_log
(
    user_id     int not null,
    timestamp   timestamp not null,
    action      varchar  not null
);

INSERT INTO facebook_web_log VALUES
(0,'2019-04-25 13:30:15','page_load'),
(0,'2019-04-25 13:30:18','page_load'),
(0,'2019-04-25 13:30:40','scroll_down'),
(0,'2019-04-25 13:30:45','scroll_up'),
(0,'2019-04-25 13:31:10','scroll_down'),
(0,'2019-04-25 13:31:25','scroll_down'),
(0,'2019-04-25 13:31:40','page_exit'),
(1,'2019-04-25 13:40:00','page_load'),
(1,'2019-04-25 13:40:10','scroll_down'),
(1,'2019-04-25 13:40:15','scroll_down'),
(1,'2019-04-25 13:40:20','scroll_down'),
(1,'2019-04-25 13:40:25','scroll_down'),
(1,'2019-04-25 13:40:30','scroll_down'),
(1,'2019-04-25 13:40:35','page_exit'),
(2,'2019-04-25 13:41:21','page_load'),
(2,'2019-04-25 13:41:30','scroll_down'),
(2,'2019-04-25 13:41:35','scroll_down'),
(2,'2019-04-25 13:41:40','scroll_up'),
(1,'2019-04-26 11:15:00','page_load'),
(1,'2019-04-26 11:15:10','scroll_down'),
(1,'2019-04-26 11:15:20','scroll_down'),
(1,'2019-04-26 11:15:25','scroll_up'),
(1,'2019-04-26 11:15:35','page_exit'),
(0,'2019-04-28 14:30:15','page_load'),
(0,'2019-04-28 14:30:10','page_load'),
(0,'2019-04-28 13:30:40','scroll_down'),
(0,'2019-04-28 15:31:40','page_exit');



-- Customer Revenue In March
create table orders(
    id int not null,
    cust_id int not null,
    order_date date not null,
    order_details varchar not null,
    total_order_cost int not null
);

INSERT INTO orders VALUES
(1,3,'2019-03-04','Coat',100),
(2,3,'2019-03-01','Shoes',80),
(3,3,'2019-03-07','Skirt',30),
(4,7,'2019-02-01','Coat',25),
(5,7,'2019-03-10','Shoes',80),
(6,15,'2019-02-01','Boats',100),
(7,15,'2019-01-11','Shirts',60),
(8,15,'2019-03-11','Slipper',20),
(9,15,'2019-03-01','Jeans',80),
(10,15,'2019-03-09','Shirts',50),
(11,5,'2019-02-01','Shoes',80),
(12,12,'2019-01-11','Shirts',60),
(13,12,'2019-03-11','Slipper',20),
(14,4,'2019-02-01','Shoes',80),
(15,4,'2019-01-11','Shirts',60),
(16,3,'2019-04-19','Shirts',50),
(17,7,'2019-04-19','Suit',150),
(18,15,'2019-04-19','Skirt',30),
(19,15,'2019-04-20','Dresses',200),
(20,12,'2019-01-11','Coat',125),
(21,7,'2019-04-01','Suit',50),
(22,7,'2019-04-02','Skirt',30),
(23,7,'2019-04-03','Dresses',50),
(24,7,'2019-04-04','Coat',25),
(25,7,'2019-04-19','Coat',125);


-- Classify Business Type
-- &
-- Number of violations
create table sf_restaurant_health_violations
(
   business_id int not null,
    business_name varchar not null,
    business_address varchar not null,
    business_city varchar not null,
    business_state varchar not null,
    business_postal_code float,
    business_latitude float,
    business_longitude float,
    business_location varchar,
    business_phone_number float ,
    inspection_id varchar not null,
    inspection_date date not null,
    inspection_score float,
    inspection_type varchar not null,
    violation_id varchar,
    violation_description varchar,
    risk_category varchar
);


-- Top Cool Votes
create table yelp_reviews(
    business_name varchar not null,
    review_id varchar not null,
    user_id varchar not null,
    stars varchar not null,
    review_date date not null,
    review_text varchar not null,
    funny int not null,
    useful int not null,
    cool int not null);

-- Order details
create table customers(
    id int not null,
    first_name varchar not null,
    last_name varchar not null,
    city varchar not null,
    address varchar,
    phone_number varchar not null
);

-- Workers with the Highest Salaries
create table worker(
    worker_id int not null,
    first_name varchar not null,
    last_name varchar not null,
    salary int not null,
    joining_date timestamp not null,
    department varchar not null
);
create table title(
    worker_ref_id int not null,
    worker_title varchar not null,
    affected_from date not null
);

-- Review of Categories
create table yelp_business(
    business_id varchar not null,
    name varchar not null,
    neighborhood varchar,
    address varchar,
    city varchar not null,
    state varchar not null,
    postal_code varchar,
    latitude float not null,
    longitude float not null,
    stars float not null,
    review_count int not null,
    is_open int not null,
    categories varchar not null
);

-- Highest Salary in Department
-- &
-- Employee and Manager Salaries
create table employee(
    id int not null,
    first_name varchar not null,
    last_name varchar not null,
    age int not null,
    sex varchar not null,
    employee_title varchar not null,
    department varchar not null,
    salary int not null,
    target int not null,
    bonus int not null,
    email varchar not null,
    city varchar not null,
    address varchar,
    manager_id int not null
);

-- Highest Target Under Manager
create table salesforce_employees(
    id int not null,
    first_name varchar not null,
    last_name varchar not null,
    age int not null,
    sex varchar not null,
    employee_title varchar not null,
    department varchar not null,
    salary int not null,
    target int not null,
    bonus int not null,
    email varchar not null,
    city varchar not null,
    address varchar,
    manager_id int not null
);

create table facebook_friends(
    user1 int not null,
    user2 int not null
);


