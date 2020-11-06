--The first trigger was to update the number of books available in the warehouses everytime
--a customer adds a book to his/her cart.
--If the number of books requested to be added to cart are greater than the number available
--in stock, an error message saying ‘not in stock’ is displayed.
-- Trigger 1
DELIMITER $$
USE `OBSM`$$
CREATE
DEFINER=`dhanik`@`localhost`
TRIGGER `OBSM`.`cart_has_books_AFTER_INSERT`
AFTER INSERT ON `OBSM`.`cart_has_books`
FOR EACH ROW
BEGIN
declare wc INT;
SET wc = (select warehouse_code from warehouse_has_books where 
warehouse_has_books.books_ISBN=NEW.books_ISBN and 
warehouse_code=(select warehouse_code from warehouse_has_books order by count desc limit 1));

UPDATE warehouse_has_books
SET warehouse_has_books.count = warehouse_has_books.count - NEW.count
WHERE (warehouse_has_books.books_ISBN = NEW.books_ISBN ) and warehouse_has_books.warehouse_code = wc;
END$$

--The second trigger was created to update the warehouse table again, but this time when
--any change is made to a user’s cart. In case a user decides to remove or add books of the
--same kind in his/her cart, a change is made in the stock corresponding with the difference in
--cart items.
--Trigger2

USE `OBSM`$$
CREATE
DEFINER=`dhanik`@`localhost`
TRIGGER `OBSM`.`cart_has_books_AFTER_UPDATE`
AFTER UPDATE ON `OBSM`.`cart_has_books`
FOR EACH ROW
BEGIN
declare wc INT;
SET wc = (select warehouse_code from warehouse_has_books where
warehouse_has_books.books_ISBN=NEW.books_ISBN and warehouse_code=(SELECT
warehouse_code from warehouse_has_books order by count asc limit 1));

UPDATE warehouse_has_books
SET warehouse_has_books.count = warehouse_has_books.count-(NEW.countOLD.count)
WHERE warehouse_has_books.books_ISBN=NEW.books_ISBN and
warehouse_has_books.warehouse_code=wc;
END$$

--The third trigger I added was to create the order logs. Everytime a customer decides to
--buy all the items in his cart, an entry is made in the ORDERS table. A trigger acts on this
--insert query to make a log of all items bought by the user and insert them in the order_items
--table. All items along with their quantity, ISBN and order ID are recorded.
--Trigger 3

CREATE DEFINER=dhanik@localhost TRIGGER OBSM.ORDERS_AFTER_INSERT AFTER
INSERT ON ORDERS FOR EACH ROW
BEGIN
declare num INT;
declare i INT;
declare l INT;
declare b_ISBN INT;
declare nid INT;
set nid=new.id;
set i=0;
select count(*) into l from cart_has_books where
cart_has_books.customer_email=new.customer_email;

while i<l do
select cart_has_books.books_ISBN into b_ISBN from cart_has_books where
cart_has_books.customer_email=new.customer_email order by
cart_has_books.books_ISBN asc limit i,1 ;

select cart_has_books.count into num from cart_has_books where
cart_has_books.customer_email=new.customer_email order by
cart_has_books.books_ISBN asc limit i,1;
set i=i+1;
insert into order_items(item_isbn,count,order_id) values(b_ISBN,num,nid);
END WHILE;
delete from cart_has_books where customer_email=new.customer_email;
END
