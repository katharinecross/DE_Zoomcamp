Module #2: Workflow Orchestration / ETL Pipelines (Kestra, Docker, Postgres, GCP)

----------- HOMEWORK -------------

Question #1:
What is the Uncompressed File Size for Yellow Taxi Data for the Year 2020 and Month 12?
128.3 MB

Question #2:
What is the Value of the Variable file when the inputs are set to : green, 2020, 04?
green_tripdata_2020-04.csv

Question #3:
How Many Rows are there for the Yellow Taxi Data for Year 2020?

QUERY:
SELECT * 
FROM public.yellow_tripdata
where filename like 'yellow_tripdata_2020%'

RESULT:
24,648,499

Question #4:
How Many Rows are there for the Green Taxi Data for the Year 2020?

QUERY:
SELECT *
FROM public.green_tripdata
where filename like 'green_tripdata_2020%'

RESULTS:
1,734,051

Question #5:
How Many Rows are there for Yellow Taxi Data for March 2021?

QUERY:
SELECT distinct(filename), count(1)
FROM public.yellow_tripdata
group by filename

RESULT:
1,925,152

QUESTION #6:
How Would You Configure the Timezone to New York in a Schedule Trigger?
Add a timezone property set to America/New_York in the Schedule trigger configuration
