-- MODELING WITH BIGQUERY

-- Column Selection
select passenger_count, trip_distance, PULocationID, DOLocationID, payment_type, fare_amount, tolls_amount, tip_amount
from sunlit-precinct-447121-u1.kc_de_zoomcamp.partitioned_yellow_tripdata_2024
where fare_amount != 0
;

-- Create ML Table 
create or replace table sunlit-precinct-447121-u1.kc_de_zoomcamp.yellow_tripdata_ml (
   passenger_count INTEGER,
  `trip_distance` FLOAT64,
  `PULocationID` STRING,
  `DOLocationID` STRING,
  `payment_type` STRING,
  `fare_amount` FLOAT64,
  `tolls_amount` FLOAT64,
  `tip_amount` FLOAT64
) AS (
SELECT passenger_count, trip_distance, cast(PULocationID AS STRING), CAST(DOLocationID AS STRING),
CAST(payment_type AS STRING), fare_amount, tolls_amount, tip_amount
from sunlit-precinct-447121-u1.kc_de_zoomcamp.partitioned_yellow_tripdata_2024 
where fare_amount != 0
)
;

-- Create Model with Default Settings
CREATE OR REPLACE MODEL `sunlit-precinct-447121-u1.kc_de_zoomcamp.tip_model`
OPTIONS
(model_type='linear_reg',
input_label_cols=['tip_amount'],
DATA_SPLIT_METHOD='AUTO_SPLIT') AS
SELECT
*
FROM
`sunlit-precinct-447121-u1.kc_de_zoomcamp.yellow_tripdata_ml`
WHERE
tip_amount IS NOT NULL;

-- Check Features
SELECT * FROM ML.FEATURE_INFO(MODEL `sunlit-precinct-447121-u1.kc_de_zoomcamp.tip_model`);

-- Evaluate Model
select *
from ML.EVALUATE(MODEL `sunlit-precinct-447121-u1.kc_de_zoomcamp.tip_model`,
  (
    select *
    from `sunlit-precinct-447121-u1.kc_de_zoomcamp.yellow_tripdata_ml`
    where tip_amount is not null
  ));

  -- Predict the Model
  select *
  from ML.PREDICT(MODEL `sunlit-precinct-447121-u1.kc_de_zoomcamp.tip_model`,
    (
      select * 
      from `sunlit-precinct-447121-u1.kc_de_zoomcamp.yellow_tripdata_ml`
      where tip_amount is not null
    ));

-- Predict & Explain
select *
from ML.EXPLAIN_PREDICT(MODEL `sunlit-precinct-447121-u1.kc_de_zoomcamp.tip_model`,
  (
      select * 
      from `sunlit-precinct-447121-u1.kc_de_zoomcamp.yellow_tripdata_ml`
      where tip_amount is not null
  ), struct(3 as top_k_features));

-- Hyper Param Tuning
CREATE OR REPLACE MODEL `sunlit-precinct-447121-u1.kc_de_zoomcamp.tip_hyperparam_model`
OPTIONS
(model_type='linear_reg',
input_label_cols=['tip_amount'],
DATA_SPLIT_METHOD='AUTO_SPLIT',
num_trials=5,
max_parallel_trials=2,
l1_reg=hparam_range(0, 20),
l2_reg=hparam_candidates([0, 0.1, 1, 10])) AS
SELECT
*
FROM
`sunlit-precinct-447121-u1.kc_de_zoomcamp.yellow_tripdata_ml`
WHERE
tip_amount IS NOT NULL;

