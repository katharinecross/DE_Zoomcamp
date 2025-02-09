-- Query Publicly Available Table
select station_id, name
from bigquery-public-data.new_york_citibike.citibike_stations
limit 100;

-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `sunlit-precinct-447121-u1.kc_de_zoomcamp.external_yellow_tripdata_2024`
OPTIONS (
  format = 'CSV',
  uris = ['gs://kc-zoomcamp-kestra-bucket/trip data/yellow_tripdata_2024-*.parquet']
);

-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE sunlit-precinct-447121-u1.kc_de_zoomcamp.non_partitioned_yellow_tripdata_2024 AS
SELECT * FROM sunlit-precinct-447121-u1.kc_de_zoomcamp.external_yellow_tripdata_2024;


-- Create a Partitioned and Clustered Table
create or replace table sunlit-precinct-447121-u1.kc_de_zoomcamp.cluster_partitioned_yellow_tripdata_2024
partition by date(tpep_dropoff_datetime) 
cluster by VendorID as
select * from sunlit-precinct-447121-u1.kc_de_zoomcamp.external_yellow_tripdata_2024
;

select count(1)
from sunlit-precinct-447121-u1.kc_de_zoomcamp.non_partitioned_yellow_tripdata_2024
;

-- Retrieve PULocation ID (bytes: 155.12 MB)
select PULocationID
from sunlit-precinct-447121-u1.kc_de_zoomcamp.non_partitioned_yellow_tripdata_2024
;

-- Retrieve PULocation ID & DOLocationID (bytes: 310.24 MB)
select PULocationID, DOLocationID
from sunlit-precinct-447121-u1.kc_de_zoomcamp.non_partitioned_yellow_tripdata_2024
;

-- External (0 B)
select count(distinct PULocationID)
from sunlit-precinct-447121-u1.kc_de_zoomcamp.external_yellow_tripdata_2024
;

-- Materialized (155.12 MB)
select count(distinct PULocationID)
from sunlit-precinct-447121-u1.kc_de_zoomcamp.non_partitioned_yellow_tripdata_2024
;

-- how many records have fare_amount = 0
select count(1)
from sunlit-precinct-447121-u1.kc_de_zoomcamp.non_partitioned_yellow_tripdata_2024
where fare_amount = 0
;

-- Create a Partitioned and Clustered Table
create or replace table sunlit-precinct-447121-u1.kc_de_zoomcamp.cluster_partitioned_yellow_tripdata_2024
partition by date(tpep_dropoff_datetime) 
cluster by VendorID as
select * from sunlit-precinct-447121-u1.kc_de_zoomcamp.external_yellow_tripdata_2024
;

-- Non Partitioned (310.24 MB)
select distinct(VendorID)
from sunlit-precinct-447121-u1.kc_de_zoomcamp.non_partitioned_yellow_tripdata_2024
where date(tpep_dropoff_datetime) between '2024-03-01' and '2024-03-15'
;

-- Partitioned (26.84 MB)
select distinct(VendorID)
from sunlit-precinct-447121-u1.kc_de_zoomcamp.cluster_partitioned_yellow_tripdata_2024
where date(tpep_dropoff_datetime) between '2024-03-01' and '2024-03-15'
;
