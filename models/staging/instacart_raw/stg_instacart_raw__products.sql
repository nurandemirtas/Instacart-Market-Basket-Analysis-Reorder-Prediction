with 

source as (

    select * from {{ source('instacart_raw', 'products') }}

),

renamed as (

    select
        cast(product_id as int64) as product_id,
        trim(cast(product_name as string)) as product_name,
        cast(aisle_id as int64) as aisle_id,
        cast(department_id as int64) as department_id

    from source

)

select * from renamed