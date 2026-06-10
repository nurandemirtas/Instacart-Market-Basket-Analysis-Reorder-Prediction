with 

source as (

    select * from {{ source('instacart_raw', 'departments') }}

),

renamed as (

    select
        cast(department_id as int64) as department_id,
        trim(cast(department as string)) as department

    from source

)

select * from renamed