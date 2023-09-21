-- Создать представление, отображающее все услуги, по которым за все время сумма
-- превысила некоторую границу

create view view_1 as
select id, service_cost
from (select services.id as id,
             sum(case
                     when is_foreign
                         then cost_foreign
                     else cost_our
                 end)    as service_cost
      from services
               left join public.works w on services.id = w.service_id
               left join public.cars c on c.id = w.car_id
      group by services.id) as service_table
where service_cost <= 1500
order by id;

select *
from view_1;

-- Создать представление, отображающее общий доход мастеров за последний год,
-- включая мастеров, которые ничего не получили


create view view_2 as
select masters.id,
       sum(case
               when c.is_foreign
                   then s.cost_foreign
               else s.cost_our
           end)
from masters
         left join works w on masters.id = w.master_id
         left join services s on w.service_id = s.id
         left join cars c on c.id = w.car_id
where date_work IS NULL or date_part('year', date_work) = date_part('year', current_date)
group by masters.id;

select * from view_2;

