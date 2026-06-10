with 

source as (

    select * from {{ source('instacart_raw', 'aisles') }}

),

renamed as (

    select
        cast(aisle_id as int64) as aisle_id,
        trim(cast(aisle as string)) as aisle

    from source

)

select * from renamed