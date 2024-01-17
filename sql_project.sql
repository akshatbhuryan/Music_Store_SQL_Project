--Q1: Who is the senior most employee based on job title?
select * from employee
order by levels desc
limit 1;


-- Q2: Which countries have the most Invoices?
select billing_country, count(invoice_id) as total_invoice from invoice
group by 1
order by total_invoice desc ;


--Q3: What are top 3 values of total invoice? 
select total from invoice
order by total desc
limit 3;


--Q4: Which city has the best customers? 
--We would like to throw a promotional Music Festival in the city we made the most money. 
--Write a query that returns one city that has the highest sum of invoice totals. 
--Return both the city name & sum of all invoice totals
select billing_city, sum(total) as total_invoice
from invoice
group by 1
order by 2 desc
limit 1;


--Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
--Write a query that returns the person who has spent the most money.
select c.customer_id, c.first_name||' '||c.last_name as name, sum(i.total) as total from customer c
join invoice i
using(customer_id)
group by 1,2
order by 3 desc
limit 1;


--Q6 Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
--Return your list ordered alphabetically by email starting with A.
select distinct email, first_name, last_name 
from customer
join invoice using(customer_id)
join invoice_line using(invoice_id)
where track_id in(
	select track_id 
	from track
	join genre using(genre_id)
	where genre.name='Rock'
)
order by email;


--Q7 Let's invite the artists who have written the most rock music in our dataset. 
--Write a query that returns the Artist name and total track count of the top 10 rock bands..
select artist.artist_id,artist.name,count(artist.artist_id) as number_of_songs from artist
join album using(Artist_Id)
join track using(album_Id)
join genre using(genre_Id)
where genre.name='Rock'
group by 1
order by 3 desc
limit 10;

--Q8 Return all the track names that have a song length longer than the average song length. 
--Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.
select name, milliseconds 
from track
where milliseconds>(
select avg(milliseconds) from track)
order by 2 desc;


--Q9 Q1: Find how much amount spent by each customer on artists? 
--Write a query to return customer name, artist name and total spent
with best_selling_artist as (
	select artist.artist_id as artist_id, artist.name as artist_name,
	sum(invoice_line.unit_price * invoice_line.quantity) as total_sales
	from invoice_line
	join track using(track_id)
	join album using(album_id)
	join artist using(artist_id)
	group by 1
	order by 3 desc
	limit 1
)
select c.customer_id, c.first_name || ' ' || c.last_name as customer_name, bsa.artist_name,
sum(il.unit_price * il.quantity) as amount_spent
from invoice i
join customer c using(customer_id)
join invoice_line il using(invoice_id)
join track t using(track_id)
join album alb using(album_id)
join best_selling_artist bsa Using(artist_id)
group by 1,2,3
order by 4 desc;


--Q10 We want to find out the most popular music Genre for each country. 
--We determine the most popular genre as the genre 
--with the highest amount of purchases. Write a query that returns each country along with the top Genre.
--For countries where 
--the maximum number of purchases is shared return all Genres.
with popular_genre as(
	select count(invoice_line.quantity) as purchases, customer.country, genre.name, genre.genre_id,
	row_number() over(partition by customer.country order by count(invoice_line.quantity) desc) as row_no
	from invoice_line
	join invoice using(invoice_id)
	join customer using(customer_id)
	join track using(track_id)
	join genre using(genre_id)
	group by 2,3,4
	order by 2 asc, 1 desc
)
select * from popular_genre where row_no=1







