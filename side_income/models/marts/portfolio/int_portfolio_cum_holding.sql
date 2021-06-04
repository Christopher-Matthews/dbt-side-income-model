select 
      ticker_symbol
    , purchase_date
    , max(cum_quantity_owned)     as cum_quantity_owned 
FROM 
    {{ ref('stg_robinhood_transactions') }}
group by 
      ticker_symbol
    , purchase_date