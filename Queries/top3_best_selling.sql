SELECT item_isbn, SUM(count) 
AS TotalQuantity
FROM OBSM.order_items
GROUP BY order_items.item_isbn
ORDER BY SUM(count) DESC
LIMIT 3