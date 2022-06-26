



with events as (
    select * from {{ref('stg_events')}}
),

session_start_end as (
select
        session_id
        , min(created_at_utc) as session_starts
        , max(created_at_utc) as session_ends
    from events
    group by 1
),

final as (
    select
        distinct events.session_id
        , events.user_id
        -- , events.session_result
        , session_start_end.session_starts
        , session_start_end.session_ends
        , {{ calc_session_length_min( 'session_starts', 'session_ends' ) }} as session_length_minutes
    from events 
        left join session_start_end on events.session_id = session_start_end.session_id
)

select * from final
