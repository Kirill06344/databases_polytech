-- Удалить статью автомобиль и все работы по нему(сделано при помощи cascade)
delete
from cars
where mark = 'Audi';


-- Удалить в рамках транзакции услуги, которые оказывались только
-- заданным мастером. Удалить работы по таким услугам этого мастера.
-- Для примера возьмем мастера с id 1
begin;

with delete_works as (delete
    from works
        where master_id = 1
            and service_id in (select service_id
                               from works
                               where service_id not in (SELECT DISTINCT service_id
                                                        FROM works
                                                        WHERE master_id <> 1)) returning service_id)

delete
from services
where id in (select * from delete_works);

commit;


