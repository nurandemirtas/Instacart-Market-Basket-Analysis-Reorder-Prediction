with

product_performance as (

    select
        product_id,
        product_name,
        aisle,
        department,

        total_order_count,
        distinct_order_count,
        unique_customer_count,
        reorder_count,
        reorder_rate,
        avg_add_to_cart_order,

        case
            when total_order_count >= 100 then true
            else false
        end as has_sufficient_order_volume,

        case
            when total_order_count >= 1000 and reorder_rate >= 0.60 then 'High Volume / High Reorder'
            when total_order_count >= 1000 and reorder_rate < 0.60 then 'High Volume / Low Reorder'
            when total_order_count < 1000 and reorder_rate >= 0.60 then 'Low Volume / High Reorder'
            else 'Low Volume / Low Reorder'
        end as product_segment

    from {{ ref('int_product_reorder_metrics') }}

)

select * from product_performance