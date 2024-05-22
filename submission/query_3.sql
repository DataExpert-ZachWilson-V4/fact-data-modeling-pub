WITH yesterday as(
    select * 
    from emmaisemma.user_devices_cumulated
    where date = date('2023-01-01')
),
today as(
    select
        w.user_id,
        d.browser_type,
        cast(date_trunc('day', w.event_time) as date) as dates_active,
        count(1)
    from bootcamp.devices d 
    left join bootcamp.web_event w 
    on d.device_id = w.device_id
    group by w.user_id, d.browser_type
)

SELECT 
    coalesce(y.user_id, t.user_id) as user_id,
    coalesce(y.browser_type, t.browser_type) as browser_type,
    case when y.dates_active is not null then array[t.dates_active]||y.dates_active
    else array[t.dates_active]
    end as dates_active,
    date('20223-01-02') as date
FROM
    yesterday y
    full outer join today t on y.user_id = t.user_id
