Select B.ISBN, B.title
from books as B
where not exists
(
    select *
    from warehouse_has_books as w
    where w.books_ISBN = B.ISBN
)