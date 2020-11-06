select author.name,books.title 
from author 
left outer join books on author.ID = books.author_ID