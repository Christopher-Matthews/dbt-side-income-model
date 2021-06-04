with dates as (
    select 
        *
    from 
        {{ ref('core_dim_date') }}
),

arcc_holdings as (
    select 
          price_date
        , ticker_symbol 
        , close_price
    from 
        {{ ref('stg_stock_arcc') }}
),

combined_holdings as ( 
    select  
          dates.date_day
        , dates.day_of_week
        , arcc_holdings.ticker_symbol
        , arcc_holdings.close_price
    from 
        dates 
    left join 
        arcc_holdings on 
            dates.date_day = arcc_holdings.price_date
    order by    
        dates.date_day 
),
 
clean_holdings as ( 
    select 
          combined_holdings.date_day
        , combined_holdings.day_of_week
        , coalesce(
            last_value(combined_holdings.ticker_symbol ignore nulls) 
                over (order by combined_holdings.date_day),
            first_value(combined_holdings.ticker_symbol ignore nulls) 
                over (order by combined_holdings.date_day 
                    RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
            )   as ticker_symbol
        , coalesce(
            last_value(combined_holdings.close_price ignore nulls) 
                over (order by combined_holdings.date_day),
            first_value(combined_holdings.close_price ignore nulls) 
                over (order by combined_holdings.date_day 
                    RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
            )   as close_price
    from 
        combined_holdings 
)

select 
    *
from 
    clean_holdings



