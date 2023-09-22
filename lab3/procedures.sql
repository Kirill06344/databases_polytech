-- Создать хранимую процедуру, выводящую все автомобили и среднюю
-- стоимость услуги для них, включая автомобили, по которым не
-- производились работы

create or replace function avg_service_car()
    returns table
            (
                num          varchar(20),
                service_cost numeric(18, 2)
            )
as
$$
select distinct ct.num, coalesce(avg(ct.service_cost) over (partition by ct.num), 0)
from (select cars.num,
             (case
                  when cars.is_foreign
                      then s.cost_foreign
                  else s.cost_our
                 end) as service_cost
      from cars
               left join works w on cars.id = w.car_id
               left join services s on s.id = w.service_id) as ct
$$
    language sql;

select *
from avg_service_car();

-- Создать хранимую процедуру, имеющую два параметра «услуга» и
-- «машина». Она должна возвращать общую стоимость этой услуги для
-- машины за все время существования автосервиса и количество проводимых
-- по этой услуге работ.

create or replace function service_stat_for_car(service varchar(50), car varchar(20))
    returns table
            (
                total_sum     integer,
                service_count integer
            )
as
$$
select service_id, car_id
from works
where service_id = (select id from services where name = $1)
  and car_id = (select id from cars where num = $2)
$$
    language sql;

select *
from service_stat_for_car('4', '344');

-- Создать хранимую процедуру с входными параметрами «мастер1» и
-- «мастер2» и выводящую количество услуг, которые оказывали оба мастера.
create or replace function count_service_for_master(master1 varchar(50), master2 varchar(50))
    returns table
            (
                name              varchar(50),
                count_of_services integer
            )
as
$$
select distinct name, count(service_id) over (partition by master_id)
from masters
         left join works w on masters.id = w.master_id
where masters.name = $1
   or masters.name = $2
$$
    language sql;

select *
from count_service_for_master('Burabek', 'Pavel');