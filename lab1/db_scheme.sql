create table services
(
    id           serial primary key,
    name         varchar(50),
    cost_our     numeric(18, 2),
    cost_foreign numeric(18, 2)
);

create table cars
(
    id         serial primary key,
    num        varchar(20),
    color      varchar(20),
    mark       varchar(20),
    is_foreign boolean
);

create table masters
(
    id   serial primary key,
    name varchar(50)
);

create table works
(
    id         serial primary key,
    date_work  date,
    master_id  integer references masters (id),
    car_id     integer references cars (id) on delete cascade ,
    service_id integer references services (id)
);