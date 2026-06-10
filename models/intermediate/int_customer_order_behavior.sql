with 

customer_orders as (

    select
        user_id,

        count(distinct order_id) as total_orders,
        min(order_number) as first_order_number,
        max(order_number) as last_order_number,

        avg(days_since_prior_order) as avg_days_since_prior_order,
        min(days_since_prior_order) as min_days_since_prior_order,
        max(days_since_prior_order) as max_days_since_prior_order,

        count(distinct case when is_first_order then order_id end) as first_order_count,
        count(distinct case when not is_first_order then order_id end) as repeat_order_count

    from {{ ref('stg_instacart_raw__orders') }}

    group by user_id

)

select * from customer_orders