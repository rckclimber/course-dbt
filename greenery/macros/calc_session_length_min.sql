{% macro calc_session_length_min(session_starts, session_ends) %}

(date_part('day', {{session_ends}} - {{session_starts}}) * 24 + 
    date_part('hour', {{session_ends}} - {{session_starts}})) * 60 + 
        date_part('minute', {{session_ends}} - {{session_starts}})

{% endmacro %}