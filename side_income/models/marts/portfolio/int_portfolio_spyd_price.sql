with dates as (
    select 
        *
    from 
        {{ ref('core_dim_date') }}
),

spyd_holdings as (
    select 
          price_date
        , ticker_symbol 
        , close_price
    from 
        {{ ref('stg_stock_spyd') }}
),

combined_holdings as ( 
    select  
          dates.date_day
        , dates.day_of_week
        , spyd_holdings.ticker_symbol
        , spyd_holdings.close_price
    from 
        dates 
    left join 
        spyd_holdings on 
            dates.date_day = spyd_holdings.price_date
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



