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



