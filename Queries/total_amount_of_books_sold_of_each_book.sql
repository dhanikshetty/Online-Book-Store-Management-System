SELECT OBSM.books.*, sum(order_items.count) as amount_sold        
from OBSM.books
left join OBSM.order_items
on (books.ISBN = order_items.item_isbn)
group by books.ISBN