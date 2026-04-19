{{ config(materialized ='incremental') }}

SELECT * FROM {{ source('staging', 'bookings') }}

{% if incremental_flag == 1 %}
    WHERE {{ incremental_col }} > (SELECT COALESCE(MAX({{ incremental_col }}), '1900-01-01') from {{ ref('bronze_bookings') }})
{% endif %}