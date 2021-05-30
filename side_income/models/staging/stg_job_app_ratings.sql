
with clean_ratings as (
  select
      ratingsID           as ratings_id 
    , jobID               as job_title_id
    , date                as ratings_date
    , beginRating         as star_rating
    , beginAccept         as acceptance_rating
    , beginCompletion     as completion_rating
    , beginOTE            as on_time_rating
    , beginFriendly       as friendliness_rating
    , beginGoodDrive      as driving_rating
    , beginCleanCar       as car_rating
    , beginAboveBeyond    as above_beyond_rating
  from  
    {{source('app_stats', 'raw_app_ratings')}}
  where 
    ratingsID is not null
)

select 
  *
from
  clean_ratings