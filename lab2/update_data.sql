-- Увеличить стоимость всех услуг на 15%
update services
set cost_our     = cost_our * 1.15,
    cost_foreign = cost_foreign * 1.15;

-- Модификация в рамках транзакции
begin;

update services
set cost_foreign = cost_foreign + 10,
    cost_our = cost_our + 10
where id =
      (select service_id
       from works
       where date_work = (select max(date_work)
                          from works));

commit;