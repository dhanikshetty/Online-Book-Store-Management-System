SELECT sum(count*price) 
FROM cart_has_books,books 
WHERE cart_has_books.books_ISBN = books.ISBN AND customer_email='any costumer email in your databse';