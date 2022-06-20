

with events as (
    select * from {{ref('stg_events')}}
),

first_last as (
select
        session_id
        , min(created_at_utc) as session_starts
        , max(created_at_utc) as session_ends
    from events
    group by 1
),

final as (
    select
        distinct e.session_id
        , e.user_id
        , first_last.session_starts
        , first_last.session_ends
        (   date_part('day', first_last.session_ends::timestamp - first_last.session_starts::timestamp) * 24 +
            date_part('hour', first_last.session_ends::timestamp - first_last.session_starts::timestamp)) * 60 +
            date_part('minute', first_last.session_ends::timestamp - first_last.session_starts::timestamp)
        as session_length_minutes
    from events e
    left join first_last on e.session_id = first_last.session_id
)

select * from final
