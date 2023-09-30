-- Необходимо реализовать хранимую
-- зарплату+премию, полученную мастером за текущий месяц. Хранимая процедура должна
-- иметь два входных параметра: мастера, для которого производим расчет и его зарплата и
-- один выходной, в котором возвращать рассчитанную сумму.
-- Предлагаемый алгоритм: создаем курсор, который пробегает по работам для
-- данного мастера.
-- Для каждой строки проверяем сколько раз для данной машины в заданном периоде
-- оказывались услуги. Если меньше 3-х, то премия составляет 5% от з/п, если больше, то 7%
-- (по каждой машине). Суммируем полученный результат в некоторой переменной,
-- значение которой по окончании работы курсора будет выдано в качестве выходного
-- параметра.

CREATE OR REPLACE FUNCTION calculate_salary_and_bonus(
    IN m_id int,
    IN base_salary decimal,
    OUT total_salary decimal
) AS
$$
DECLARE
    bonus      DECIMAL := 0;
    cars_count int;
    service_cursor CURSOR is
        SELECT car_id, COUNT(*) AS service_count
        FROM works
        WHERE master_id = m_id
          AND DATE_TRUNC('month', date_work) = DATE_TRUNC('month', CURRENT_DATE)
        GROUP BY car_id;
BEGIN
    total_salary := base_salary;

    FOR car_record IN service_cursor
        LOOP
            cars_count := car_record.service_count;

            IF cars_count < 3 THEN
                bonus := bonus + (0.05 * base_salary);
            ELSE
                bonus := bonus + (0.07 * base_salary);
            END IF;
        END LOOP;


    total_salary := total_salary + bonus;
END;
$$ LANGUAGE plpgsql;

select *
from calculate_salary_and_bonus(2, 15000);

