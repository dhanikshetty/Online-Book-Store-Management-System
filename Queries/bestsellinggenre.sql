SELECT genre FROM books
WHERE ISBN=
(
SELECT item_isbn AS bestsold
FROM OBSM.order_items
GROUP BY order_items.item_isbn
ORDER BY SUM(count) 
DESC LIMIT 1
)