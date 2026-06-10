with 

source as (

    select * from {{ source('instacart_raw', 'order_products_prior') }}

),

renamed as (

    select
        cast(order_id as int64) as order_id,
        cast(product_id as int64) as product_id,
        cast(add_to_cart_order as int64) as add_to_cart_order,
        cast(reordered as int64) as reordered,

        case
            when reordered = 1 then true
            else false
        end as is_reordered

    from source

)

select * from renamed