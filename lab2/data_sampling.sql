-- Вывести все работы за последний месяц
select *
from works
where date_work >= date_trunc('month', current_date - interval '1 month')
  and date_work < date_trunc('month', current_date);

-- Вычислить общее услуг и общую сумму стоимости для отечественных и
-- импортных автомобилей


-- Вывести стоимость обслуживания каждого автомобиля за последний год,
-- включая автомобили, которые не обслуживались, упорядочив по убыванию
-- стоимости
select t.id as car_id, t.service_cost
from (select c.id,
             sum(case
                     when c.is_foreign
                         then s.cost_foreign
                     else s.cost_our
                 end) as service_cost
      from works w
               left join cars c on c.id = car_id
               left join services s on service_id = s.id
      where date_part('year', w.date_work) = date_part('year', current_date)
      group by c.id
      order by c.id) as t;


