SELECT 
	prod_id, 
	prod_name,
	prod_price
FROM 
	products;

SELECT
	prod_name
FROM
	products
ORDER BY
	prod_name;


SELECT 
	prod_id, 
	prod_name,
	prod_price
FROM 
	products
ORDER BY
	prod_price, prod_name;


SELECT
	vend_id,
	prod_name,
	prod_price
FROM
	products
WHERE
	vend_id IN('DLL01', 'BRS01');


SELECT 
	prod_id, 
	prod_name,
	prod_price
FROM 
	products
WHERE
	prod_name LIKE '%bean bag%';


SELECT
	prod_id,
	prod_name
FROM
	Products
WHERE
	prod_name LIKE "_ inch teddy bear";




SELECT
	cust_contact
FROM
	Customers
WHERE
	cust_contact LIKE 'M%';



SELECT 
	vend_name || '(' || vend_country || ')'
FROM
	Vendors;




SELECT
	prod_id,
	quantity,
	item_price,
	quantity * item_price AS total_price
FROM
	OrderItems
WHERE
	order_num = 20008;




SELECT 
	vend_name as vend_name_longlong,
	LENGTH(vend_name)
FROM
	Vendors;



SELECT
	cust_name, 
	cust_contact
FROM
	Customers
WHERE
	SOUNDEX(cust_contact) = SOUNDEX('Michael Green');

SELECT LEFT("ABC",1);
SELECT LENGTH("ABC");
SELECT UPPER("Aac");


SELECT 
	order_num,
	strftime('%Y', order_date)
FROM 
	orders;


SELECT PI();


SELECT
	COUNT(*),
	prod_price,
	prod_price+1 as aa
FROM
	Products
GROUP BY	
	aa;

SELECT 
	cust_email,
	COUNT(*) 
FROM 
	Customers 
GROUP BY 
	cust_email;


SELECT COUNT(*) FROM Customers WHERE cust_email IS NULL; 

SELECT COUNT(*) FROM Customers WHERE cust_email IS NOT NULL; 

SELECT 
	cust_state || cust_country AS a,
	COUNT(*)
FROM 
	Customers
GROUP BY
	a;



SELECT
	*
FROM
	Customers;


SELECT
	cust_id,
	cust_name,
	(SELECT
		COUNT(*)
	FROM
		Orders
	WHERE
		Orders.cust_id == Customers.cust_id) as orders
FROM
	Customers
ORDER BY
	cust_name;

SELECT
	C.cust_id,
	O.order_num
FROM
	Customers C
	JOIN 
	Orders O
	ON C.cust_id = O.cust_id;


INSERT INTO 
	Customers(
				cust_id,
				cust_name,
				cust_address,
				cust_city,
				cust_state,
				cust_zip,
				cust_country,
				cust_contact,
				cust_email)
VALUES(
	'1000000007',
	'Toy Land2',
	'123 Any Street',
	'New York',
	'NY',
	'111111',
	'USA',
	NULL,
	NULL);


CREATE TABLE
	CustCopy AS
		SELECT *
		FROM Customers；

UPDATE
	Customers
SET
	cust_name='Just Tony'
WHERE
	cust_id = 1000000007;


DELETE FROM
	Customers
WHERE
	cust_id = 1000000007;


SELECT date('now')

CREATE VIEW 
	ProductCustomers AS
SELECT
	cust_name,
	cust_contact,
	prod_id
FROM
	Customers,
	Orders,
	OrderItems
WHERE
	Customers.cust_id = Orders.cust_id
	AND
	OrderItems.order_num = Orders.order_num;


SELECT
	cust_name,
	cust_contact
FROM
	ProductCustomers
WHERE
	prod_id = 'RGAN01';



select * from sqlite_master where type="index";






