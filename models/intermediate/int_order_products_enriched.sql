with 

order_products as (

    select
        order_id,
        product_id,
        add_to_cart_order,
        reordered,
        is_reordered,
        'prior' as order_product_source

    from {{ ref('stg_instacart_raw__order_products_prior') }}

    union all

    select
        order_id,
        product_id,
        add_to_cart_order,
        reordered,
        is_reordered,
        'train' as order_product_source

    from {{ ref('stg_instacart_raw__order_products_train') }}

),

enriched as (

    select
        op.order_id,
        o.user_id,
        o.eval_set,
        o.order_number,
        o.order_day_of_week,
        o.order_hour_of_day,
        o.days_since_prior_order,
        o.is_first_order,

        op.product_id,
        p.product_name,
        p.aisle_id,
        a.aisle,
        p.department_id,
        d.department,

        op.add_to_cart_order,
        op.reordered,
        op.is_reordered,
        op.order_product_source

    from order_products op

    left join {{ ref('stg_instacart_raw__orders') }} o
        on op.order_id = o.order_id

    left join {{ ref('stg_instacart_raw__products') }} p
        on op.product_id = p.product_id

    left join {{ ref('stg_instacart_raw__aisles') }} a
        on p.aisle_id = a.aisle_id

    left join {{ ref('stg_instacart_raw__departments') }} d
        on p.department_id = d.department_id

)

select * from enriched