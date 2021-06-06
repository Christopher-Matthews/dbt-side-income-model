with arcc_position as (
  select 
    *
  from 
    {{ ref('portfolio_running_arcc_position') }}
),

spyd_position as (
  select 
    *
  from 
    {{ ref('portfolio_running_spyd_position') }}
),

joined_position as (
  select 
      arcc_position.date_day
    , round(
        arcc_position.total_running_position + spyd_position.total_running_position 
        , 2
      )                                                   as total_position
  from 
    arcc_position
  inner join 
    spyd_position on 
      arcc_position.date_day = spyd_position.date_day
  order by 
    arcc_position.date_day
)

select
  * 
from 
  joined_position