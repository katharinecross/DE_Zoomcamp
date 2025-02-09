Module #3: Datawarehouse, GCP & BigQuery, ML

----------- HOMEWORK -------------

Question #1:
What is Count of Records for the 2024 Yellow Taxi Data?

QUERY:
select count(1)
from sunlit-precinct-447121-u1.kc_de_zoomcamp.non_partitioned_yellow_tripdata_2024

RESULT:
20,332,093

Question #2:
Write a Query to Count the Distinct Number of PULocationIDs for the Entire Dataset on Both Tables.
What is the Estimated Amount of Data that will be Read when Executed on the External Table and the Materialized Table?

QUERY:
-- External (0 B)
select count(distinct PULocationID)
from sunlit-precinct-447121-u1.kc_de_zoomcamp.external_yellow_tripdata_2024
;

-- Materialized (155.12 MB)
select count(distinct PULocationID)
from sunlit-precinct-447121-u1.kc_de_zoomcamp.non_partitioned_yellow_tripdata_2024
;

RESULTS:
0 MB for the External Table and 155.12 MB for the Materialized Table

Question #3:
Write a Query to Retrieve the PULocationID from the table. Now Write a Query to Retrieve the PULocationID and DOLocationID on the same table. Why are the Estimated Number of Bytes Different?

QUERY:
-- Retrieve PULocation ID (bytes: 155.12 MB)
select PULocationID
from sunlit-precinct-447121-u1.kc_de_zoomcamp.non_partitioned_yellow_tripdata_2024
;

-- Retrieve PULocation ID & DOLocationID (bytes: 310.24 MB)
select PULocationID, DOLocationID
from sunlit-precinct-447121-u1.kc_de_zoomcamp.non_partitioned_yellow_tripdata_2024
;

ANSWER:
Big Query is a Columnar Database, and it only Scans the Specific Columns Requested. Querying Two Columns Requires Reading More data than Querying One. Which Leads to a Higher Estimated Number of Bytes Processed.

Question #4:
How Many Records Have a Fare Amount of 0?

QUERY:
select count(1)
from sunlit-precinct-447121-u1.kc_de_zoomcamp.non_partitioned_yellow_tripdata_2024
where fare_amount = 0
;

ANSWER:
8,333

Question #5:
What is the Best Strategy to make an Optimized Table in BigQuery if your Query will Always Filter based on tpep_dropoff_datetime and order the results by VendorID?

QUERY:
-- Create a Partitioned and Clustered Table
create or replace table sunlit-precinct-447121-u1.kc_de_zoomcamp.cluster_partitioned_yellow_tripdata_2024
partition by date(tpep_dropoff_datetime) 
cluster by VendorID as
select * from sunlit-precinct-447121-u1.kc_de_zoomcamp.external_yellow_tripdata_2024
;

ANSWER:
Partition By tpep_dropoff_datetime and Cluster on VendorID

Question #6:
Write a Query to Retrieve the Distinct VendorIDs Between tpep_dropoff_datetime 03/01/2024 and 03/15/2024 (inclusive)
Note the Bytes for the Materialized Table and the Bytes for the Partitioned Table.

QUERY:
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

ANSWER:
310.24 MB for Non Partitioned Table and 26.84 MB for the Partitioned Table.

Question #7:
Where is the Data Stored in the External Table you Created?
GCP Bucket

Question #8:
It is Best Practice in Big Query to Always Cluster your Data:
False
