-- Добавить новую услугу
insert into services(name, cost_our, cost_foreign)
VALUES ('Мойка ковриков', '300', '500');

-- Добавить работу по новой услуге из п1
insert into works(date_work, master_id, car_id, service_id)
VALUES ('2023-02-17', 1, 3,);

-- Добавить в рамках транзакции новый автомобиль и услугу и провести
-- работу для этого автомобиля по новой услуге.
begin;

with insert_car as (insert into cars (num, color, mark, is_foreign)
    VALUES ('044', 'red', 'Toyota', true) returning id),
     insert_service as (
         insert
             into services (name, cost_our, cost_foreign)
                 VALUES ('Мойка фар', '400', '700')
                 returning id)

insert
into works(date_work, master_id, car_id, service_id)
VALUES ('2023-11-11', 1, (select * from insert_car), (select * from insert_service));

commit;