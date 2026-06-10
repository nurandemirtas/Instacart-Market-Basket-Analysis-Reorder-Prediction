with

reorder_analysis as (

    select
        department,
        aisle,

        count(*) as total_order_count,
        count(distinct order_id) as distinct_order_count,
        count(distinct product_id) as product_count,
        count(distinct user_id) as unique_customer_count,

        sum(reordered) as reorder_count,
        safe_divide(sum(reordered), count(*)) as reorder_rate,

        avg(add_to_cart_order) as avg_add_to_cart_order

    from {{ ref('int_order_products_enriched') }}

    group by
        department,
        aisle

)

select * from reorder_analysis