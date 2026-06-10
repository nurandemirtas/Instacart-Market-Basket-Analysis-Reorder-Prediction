with

customer_product_behavior as (

    select
        user_id,

        count(distinct order_id) as total_orders,
        count(product_id) as total_products_ordered,
        count(distinct product_id) as unique_products_ordered,

        sum(reordered) as reordered_product_count,
        safe_divide(sum(reordered), count(product_id)) as customer_reorder_rate,

        avg(add_to_cart_order) as avg_add_to_cart_order

    from {{ ref('int_order_products_enriched') }}

    group by user_id

),

customer_order_behavior as (

    select
        user_id,
        avg_days_since_prior_order,
        min_days_since_prior_order,
        max_days_since_prior_order,
        first_order_count,
        repeat_order_count

    from {{ ref('int_customer_order_behavior') }}

),

final as (

    select
        cpb.user_id,

        cpb.total_orders,
        cpb.total_products_ordered,
        cpb.unique_products_ordered,
        cpb.reordered_product_count,
        cpb.customer_reorder_rate,
        cpb.avg_add_to_cart_order,

        cob.avg_days_since_prior_order,
        cob.min_days_since_prior_order,
        cob.max_days_since_prior_order,
        cob.first_order_count,
        cob.repeat_order_count,

        safe_divide(cpb.total_products_ordered, cpb.total_orders) as avg_basket_size,

        case
            when cpb.total_orders >= 10 and cpb.customer_reorder_rate >= 0.60 then 'Loyal High-Frequency Customer'
            when cpb.total_orders >= 10 and cpb.customer_reorder_rate < 0.60 then 'Frequent Low-Reorder Customer'
            when cpb.total_orders < 10 and cpb.customer_reorder_rate >= 0.60 then 'Occasional Loyal Customer'
            else 'Occasional Low-Reorder Customer'
        end as customer_segment

    from customer_product_behavior cpb

    left join customer_order_behavior cob
        on cpb.user_id = cob.user_id

)

select * from final