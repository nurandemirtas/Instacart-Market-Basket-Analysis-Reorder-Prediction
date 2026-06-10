with 

source as (

    select * from {{ source('instacart_raw', 'orders') }}

),

renamed as (

    select
        cast(order_id as int64) as order_id,
        cast(user_id as int64) as user_id,
        cast(eval_set as string) as eval_set,
        cast(order_number as int64) as order_number,
        cast(order_dow as int64) as order_day_of_week,
        cast(order_hour_of_day as int64) as order_hour_of_day,
        cast(days_since_prior_order as float64) as days_since_prior_order,

        case
            when days_since_prior_order is null then true
            else false
        end as is_first_order

    from source

)

select * from renamed