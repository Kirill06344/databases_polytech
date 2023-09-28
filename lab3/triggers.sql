-- Создать триггер, который не позволяет добавить автомобиль с уже
-- существующим номером

create or replace function insert_car_trigger()
    returns trigger
    language plpgsql
as
$$
begin
    if (select count(id) from cars where num = new.num) = 0 then
        return new;
    end if;
    raise notice 'Car with num % already exists!', new.num;
    return old;
end;
$$;


create trigger unique_num
    before insert
    on cars
    for each row
execute procedure insert_car_trigger();

insert into cars (num, color, mark, is_foreign)
values (344, 'sas', 'sasa', true);

-- Создать триггер, который не позволяет изменить дату работы более чем на
-- один день


create or replace function change_date()
    returns trigger
    language plpgsql
as
$$
begin
    if abs(new.date_work - old.date_work) > 1 then
        raise notice 'You can not change date for more than one day!';
        return old;
    end if;
    return new;
end;
$$;

create trigger change_date
    before update
    on works
    for each row
execute procedure change_date();

update works
set date_work = '2023-01-12'
where id = 1;

-- Создать триггер, который при удалении автомобиля,
-- были какие-то работы, откатывает транзакцию

create or replace function rollback_delete_car()
    returns trigger
    language plpgsql
as
$$
begin
    if (select count(id) from works where car_id = old.id) <> 0 then
        raise notice 'Car with num % has got works, so can not be deleted!', old.num;
        return null;
    end if;
    return old;
end;
$$;


create trigger delete_car
    before delete
    on cars
    for each row
execute procedure rollback_delete_car();

delete from cars where id = 1;
