/*
создать таблицы со следующими структурами и загрузить данные из csv-файлов (описание приведено ниже);

выполнить следующие запросы:
вывести распределение (количество) клиентов по сферам деятельности, отсортировав результат по убыванию количества. — (1 балл)
найти сумму транзакций за каждый месяц по сферам деятельности, отсортировав по месяцам и по сфере деятельности. — (1 балл)
вывести количество онлайн-заказов для всех брендов в рамках подтвержденных заказов клиентов из сферы it. — (1 балл)
найти по всем клиентам сумму всех транзакций (list_price), максимум, минимум и количество транзакций, отсортировав результат по убыванию суммы транзакций и количества клиентов. выполните двумя способами: используя только group by и используя только оконные функции. сравните результат. — (2 балла)
найти имена и фамилии клиентов с минимальной/максимальной суммой транзакций за весь период (сумма транзакций не может быть null). напишите отдельные запросы для минимальной и максимальной суммы. — (2 балла)
вывести только самые первые транзакции клиентов. решить с помощью оконных функций. — (1 балл)
вывести имена, фамилии и профессии клиентов, между транзакциями которых был максимальный интервал (интервал вычисляется в днях) — (2 балла).
 * */

-- создать таблицы со следующими структурами и загрузить данные из csv-файлов
drop table if exists customer_20240101;
drop table if exists transaction_20240101;

create table customer_20240101 (
    customer_id           int,
    first_name            varchar(50),
    last_name             varchar(50),
    gender                varchar(50),
    dob                   date,
    job_title             varchar(100),
    job_industry_category varchar(50),
    wealth_segment        varchar(50),
    deceased_indicator    varchar(50),
    owns_car              varchar(50),
    address               varchar(100),
    postcode              varchar(30),
    state                 varchar(50),
    country               varchar(50),
    property_valuation    int
);

create table transaction_20240101 (
    transaction_id   int,
    product_id       int,
    customer_id      int,
    transaction_date date,
    online_order     boolean,
    order_status     varchar(30),
    brand            varchar(50),
    product_line     varchar(30),
    product_class    varchar(30),
    product_size     varchar(30),
    list_price       numeric(10,2),
    standard_cost    numeric(10,2)
);

-- вывести распределение (количество) клиентов по сферам деятельности, отсортировав результат по убыванию количества. — (1 балл)

select 
    job_industry_category,
    count(*) as cnt_clients
from customer_20240101
group by job_industry_category
order by cnt_clients desc;


-- найти сумму транзакций за каждый месяц по сферам деятельности, отсортировав по месяцам и по сфере деятельности. — (1 балл)

select
    date_trunc('month', t.transaction_date)::date as months,
    c.job_industry_category,
    sum(t.list_price) as sum_transactions
from transaction_20240101 t
join customer_20240101 c
  on t.customer_id = c.customer_id
group by
    date_trunc('month', t.transaction_date),
    c.job_industry_category
order by
    months,
    c.job_industry_category;


-- вывести количество онлайн-заказов для всех брендов в рамках подтвержденных заказов клиентов из сферы it. — (1 балл)

select
    t.brand,
    count(*) as cnt_online_orders
from transaction_20240101 t
join customer_20240101 c
  on t.customer_id = c.customer_id
where t.online_order = true
  and t.order_status = 'approved'
  and c.job_industry_category = 'it'
group by t.brand
order by cnt_online_orders desc;


-- найти по всем клиентам сумму всех транзакций (list_price), максимум, минимум и количество транзакций, отсортировав результат по убыванию суммы транзакций и количества клиентов. выполните двумя способами: используя только group by и используя только оконные функции. сравните результат. — (2 балла)

--- вариант 1
select
    c.customer_id,
    c.first_name,
    c.last_name,
    sum(t.list_price) as total_sum,
    max(t.list_price) as max_price,
    min(t.list_price) as min_price,
    count(*) as cnt_transactions
from transaction_20240101 t
join customer_20240101 c
  on t.customer_id = c.customer_id
group by
    c.customer_id,
    c.first_name,
    c.last_name
order by
    total_sum desc,
    cnt_transactions desc;

--- вариант 2
select distinct
    c.customer_id,
    c.first_name,
    c.last_name,
    -- оконные функции:
    sum(t.list_price) over (partition by c.customer_id) as sum_list_price,
    max(t.list_price) over (partition by c.customer_id) as max_list_price,
    min(t.list_price) over (partition by c.customer_id) as min_list_price,
    count(t.list_price) over (partition by c.customer_id) as count_list_price
from transaction_20240101 t
join customer_20240101 c
  on t.customer_id = c.customer_id
order by
    sum_list_price desc,
    count_list_price desc;


-- найти имена и фамилии клиентов с минимальной/максимальной суммой транзакций за весь период (сумма транзакций не может быть null). напишите отдельные запросы для минимальной и максимальной суммы. — (2 балла)

--- мин
with sums as (
    select
        c.customer_id,
        c.first_name,
        c.last_name,
        sum(t.list_price) as total_spent
    from transaction_20240101 t
    join customer_20240101 c
      on t.customer_id = c.customer_id
    group by c.customer_id, c.first_name, c.last_name
)
select
    customer_id,
    first_name,
    last_name,
    total_spent
from sums
where total_spent = (select min(total_spent) from sums);

--- макс
with sums as (
    select
        c.customer_id,
        c.first_name,
        c.last_name,
        sum(t.list_price) as total_spent
    from transaction_20240101 t
    join customer_20240101 c
      on t.customer_id = c.customer_id
    group by c.customer_id, c.first_name, c.last_name
)
select
    customer_id,
    first_name,
    last_name,
    total_spent
from sums
where total_spent = (select max(total_spent) from sums);


-- вывести только самые первые транзакции клиентов. решить с помощью оконных функций. — (1 балл)

select
    c.customer_id,
    c.first_name,
    c.last_name,
    t.transaction_id,
    t.transaction_date,
    t.list_price
from (
    select
        t.*,
        row_number() over (partition by t.customer_id 
                           order by t.transaction_date asc, t.transaction_id asc) as rn
    from transaction_20240101 t
) t
join customer_20240101 c
  on t.customer_id = c.customer_id
where t.rn = 1
order by t.transaction_date;


-- вывести имена, фамилии и профессии клиентов, между транзакциями которых был максимальный интервал (интервал вычисляется в днях) — (2 балла).

with lag_days as (
    select
        c.customer_id,
        c.first_name,
        c.last_name,
        c.job_title,
        t.transaction_date,
        lag(t.transaction_date) over (
            partition by t.customer_id
            order by t.transaction_date
        ) as prev_transaction_date
    from transaction_20240101 t
    join customer_20240101 c
      on t.customer_id = c.customer_id
),
diffs_days as (
	select
	    customer_id,
	    first_name,
	    last_name,
	    job_title,
	    transaction_date,
	    prev_transaction_date,
	    (transaction_date - prev_transaction_date) as diff_days
	from lag_days
	where prev_transaction_date is not null
),
max_interval as (
    select max(diff_days) as max_diff
    from diffs_days
)
select
    d.customer_id,
    d.first_name,
    d.last_name,
    d.job_title,
    d.diff_days as max_interval_days
from diffs_days d
join max_interval m
  on d.diff_days = m.max_diff;
