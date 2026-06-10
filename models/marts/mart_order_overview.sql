with

order_overview as (

    select
        order_id,
        user_id,
        eval_set,
        order_number,
        order_day_of_week,
        order_hour_of_day,
        days_since_prior_order,
        is_first_order,

        count(product_id) as basket_size,
        sum(reordered) as reordered_product_count,
        safe_divide(sum(reordered), count(product_id)) as order_reorder_rate

    from {{ ref('int_order_products_enriched') }}

    group by
        order_id,
        user_id,
        eval_set,
        order_number,
        order_day_of_week,
        order_hour_of_day,
        days_since_prior_order,
        is_first_order

)

select * from order_overview