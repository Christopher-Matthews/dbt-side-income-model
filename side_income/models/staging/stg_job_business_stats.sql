
with clean_service as (
  select 
      businessID            as business_id
    , businessName          as business_name
    , doordashStarRating    as business_star_rating
    , numDoordashRatings    as num_business_rating
    , numDollarSigns        as business_price_rating
    , foodType              as business_food_type
  from 
    {{source('app_stats', 'raw_business_stats')}}
  where 
    businessID is not null
)

select 
  *
from 
  clean_service