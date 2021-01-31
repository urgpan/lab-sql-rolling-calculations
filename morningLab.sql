#first
drop view if exists user_activity; 
create or replace view user_activity as
select rental_id, customer_id, convert(rental_date, date) as Rented_date,
date_format(convert(rental_date,date), '%M') as Rental_Month,
date_format(convert(rental_date,date), '%m') as Rental_Month_number,
date_format(convert(rental_date,date), '%Y') as Rental_year
from sakila.rental;


select count(rental_id), Rental_Month
from user_activity as u
join customer as c
on u.customer_id = c.customer_id 
where c.active = True
group by  Rental_Month;

#second
drop view if exists user_activity1; 
create or replace view user_activity1 as
	select 
    rental_id,
    Rental_year,
    count(rental_id) as counted, 
    Rental_Month,Rental_Month_number
	from user_activity as u
	join customer as c
	on u.customer_id = c.customer_id 
	where c.active = True
	group by  Rental_Month;
    

select 
	Rental_year,
	Rental_Month, 
	counted, 
	lag(counted,1) over (order by Rental_Month_number) 
from user_activity1;

#THIRD
select 	
	Rental_Month, 
	counted, 
	lag(counted,1) over (order by Rental_Month_number),
    round((100 - (lag(counted,1) over (order by Rental_Month_number) * 100/ counted) ),2) as percentage
from user_activity1;

#forth

select 	
	count(distinct(p.customer_id)) as NewUsers,
    #count(distinct(r.rental_id)),
	date_format(convert(r.rental_date,date), '%m') as Rental_Month_number,
	date_format(convert(r.rental_date,date), '%Y') as Rental_year

from rental as r
left join payment as p
on r.rental_id = p.rental_id
group by Rental_Month_number, Rental_year
;


