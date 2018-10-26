Use sakila;
/* 1.a. Display First and Last Name of all actors*/
select distinct
	 first_name
	,last_name
 from actor;

/*1.b.Display the first and last name of each actor in a single column 
in upper case letters. Name the column Actor Name*/
select distinct
	 concat(first_name, ' ', last_name) as 'Actor Name'
from actor;
 
 /*2.1.You need to find the ID number, first name, and last name of an actor, 
 of whom you know only the first name, "Joe." 
 What is one query would you use to obtain this information? */
select distinct 
	 actor_id
    ,first_name
    ,last_name
from actor
where first_name = 'Joe';

/*2.2.Find all actors whose last name contain the letters GEN*/
select distinct *
from actor
where last_name like '%GEN%';

/*2.3.Find all actors whose last names contain the letters LI. 
This time, order the rows by last name and first name, in that order:*/
select distinct *
from actor
where last_name like '%LI%'
order by last_name, first_name;

/*2.4.Using IN, display the country_id and country columns of the following countries: 
Afghanistan, Bangladesh, and China*/
select distinct 
	 country_id
	,country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

/*3.1.Create a column in the table actor named description and use the data type BLOB */
alter table actor
add column description BLOB after last_name;
select * from actor;

/*3.2.Delete the description column*/
alter table actor
drop column description;
select * from actor;

/*4.1.List the last names of actors, as well as how many actors have that last name*/
select a.*,
(select count(1) 
from actor a1
where a1.last_name = a.last_name
) as 'count_lastname'
from actor a;

/*4.2.List last names of actors and the number of actors who have that last name, 
but only for names that are shared by at least two actors*/
select * 
from
	(select a.*,
		(select count(1) 
		from actor a1
		where a1.last_name = a.last_name
		) as 'count_lastname'
	from actor a) b
where b.count_lastname >1;

/*4.3.The actor HARPO WILLIAMS was accidentally entered in the actor table 
as GROUCHO WILLIAMS. Write a query to fix the record */
UPDATE actor
SET first_name = 'HARPO'
WHERE	first_name = 'GROUCHO'
and		last_name = 'WILLIAMS';
select * from actor
where 	first_name = 'HARPO'
and		last_name = 'WILLIAMS';

/*4.4.In a single query, if the first name of the actor is currently HARPO, 
change it to GROUCHO*/
UPDATE actor
SET first_name = 'GROUCHO'
WHERE	first_name = 'HARPO'
and		last_name = 'WILLIAMS';
select * from actor
where 	first_name = 'GROUCHO'
and		last_name = 'WILLIAMS';

/*5.1.You cannot locate the schema of the address table. 
Which query would you use to re-create it?*/
show create table address;

/*6.1.Use JOIN to display the first and last names, as well as the address, 
of each staff member. Use the tables staff and address*/
select distinct 
	 s.first_name
	,s.last_name
    ,a.address
from staff s
join address a on s.address_id = a.address_id;

/*6.2.Use JOIN to display the total amount rung up by each staff member in August of 2005. 
Use tables staff and payment*/
select 
	 s.first_name
    ,s.last_name
    ,sum(p.amount) as 'amount'
from staff s
join payment p on p.staff_id = s.staff_id
group by s.staff_id, s.first_name, s.last_name;

/*6.3.List each film and the number of actors who are listed for that film. 
Use tables film_actor and film. Use inner join*/
select 
	 f.title
    ,count(1) as 'count_actors'
from film_actor fa
inner join film f on f.film_id = fa.film_id
group by f.film_id;

/*6.4.How many copies of the film Hunchback Impossible exist in the inventory system*/
select 
	 f.title
    ,count(1) as 'count_inventory'
from inventory i
inner join film f on f.film_id = i.film_id
where f.title = 'Hunchback Impossible'
group by f.film_id;

/*6.5.Using the tables payment and customer and the JOIN command, 
list the total paid by each customer. List the customers alphabetically by last name*/
select
	 c.first_name
    ,c.last_name
	,sum(p.amount) as 'customer_paid'
from payment p 
join customer c on c.customer_id = p.customer_id
group by p.customer_id
order by c.last_name,c.first_name;

/*7.1.Use subqueries to display the titles of movies starting with 
the letters K and Q whose language is English.*/
select 
	 p.title
	,l.name as 'language'
from
(select distinct 
	 title
    ,language_id
from film
where title like 'K%'
union
select distinct 
	 title
    ,language_id
from film
where title like 'Q%') p
left join language l on l.language_id = p.language_id
where l.name = 'english';

/*7.2.Use subqueries to display all actors who appear in the film Alone Trip*/
select 
	 f.title
	,concat(a.first_name,' ',a.last_name) as 'Actor Name'
from film_actor fa
inner join film f on f.film_id = fa.film_id
left join actor a on a.actor_id = fa.actor_id
where f.title = 'Alone Trip';

/*7.3.Use joins to retrieve the names and email addresses of all Canadian customers.*/
select
	concat(c.first_name, ' ', c.last_name) as 'Customer Name'
   ,c.email
from customer c
inner join address a on a.address_id = c.address_id
inner join city ci on ci.city_id = a.address_id
inner join country ct on ct.country_id = ci.country_id
where ct.country = 'Canada';

/*7.4.Identify all movies categorized as family films*/
select 
	 f.title
	,fc.name as 'category'
from film f
inner join
(select distinct f.category_id, f.film_id, c.name from film_category f
left join category c on c.category_id = f.category_id 
where c.name = 'Family') fc on fc.film_id = f.film_id;

/*7.5.Display the most frequently rented movies in descending order*/
select 
	 f.title
    ,count(1) as 'times_rented'
from film f
inner join inventory i on f.film_id = i.film_id
inner join customer c on c.store_id = i.store_id
inner join rental r on r.customer_id = c.customer_id and r.inventory_id = i.inventory_id
group by f.film_id;

/*7.6.Write a query to display how much business, in dollars, each store brought in.*/
select 
	 f.store_id
	,sum(amount) as 'amount'
from payment p
inner join staff f on f.staff_id = p.staff_id
group by f.store_id;

/*7.7.Write a query to display for each store its store ID, city, and country.*/
select 
	 s.store_id
	,c.city
    ,ct.country
from store s
inner join address a on a.address_id = s.address_id
inner join city c on a.city_id = c.city_id
inner join country ct on c.country_id = ct.country_id;

/*7.8.List the top five genres in gross revenue in descending order.*/
select 
	 c.category_id
	,c.name as 'category_name'
    ,sum(p.amount) as 'amount'
from category c 
inner join film_category fc on c.category_id = fc.category_id
left join inventory i on i.film_id = fc.film_id
left join rental r on r.inventory_id = i.inventory_id
left join payment p on p.rental_id = r.rental_id
group by c.category_id, c.name
order by amount desc
limit 5;

/*8.1. In your new role as an executive, you would like to have an easy way of viewing the 
Top five genres by gross revenue. Use the solution from the problem above to create a view. 
If you haven't solved 7h, you can substitute another query to create a view*/
create view Top5Genres as 
select
	 c.category_id
	,c.name as 'category_name'
    ,sum(p.amount) as 'amount'
from category c 
inner join film_category fc on c.category_id = fc.category_id
left join inventory i on i.film_id = fc.film_id
left join rental r on r.inventory_id = i.inventory_id
left join payment p on p.rental_id = r.rental_id
group by c.category_id, c.name
order by amount desc
limit 5;
/*8.2.How would you display the view that you created in 8a*/
select * from top5genres;
/*8.3.You find that you no longer need the view top_five_genres. 
Write a query to delete it.*/
drop view top5genres;