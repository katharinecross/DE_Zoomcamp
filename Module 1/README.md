Module #1: Docker, Postgres, & Terraform

----------- HOMEWORK -------------

Question #1 (Docker First Run):
winpty docker run -it --entrypoint=bash python:3.12.8
pip --version
pip 24.3.1

Question #2 (Docker Networking & Docker Compose):
What is the Hostname and Port PgAdmin Should Use?
postgres:5432

Questin #3 (Trip Segmentation Count):
How Many Trips Happened: Up to One Mile, Between 1 & 3 Miles, Between 7 & 10 Miles, and Over 10 Miles?


Question #4 (Longest Trip):
Which Day Had the Longest Trip Distance?

QUERY:
select 
lpep_pickup_datetime,
lpep_dropoff_datetime,
max(trip_distance)
from green_taxi_2019_10
where cast (lpep_pickup_datetime as DATE) = cast(lpep_dropoff_datetime as date)
group by
lpep_pickup_datetime,
lpep_dropoff_datetime
order by max(trip_distance) desc
;

RESULT:
2019-10-11 (distance of 95.78)

Question #5 (Biggest Pickup Zones):
Which Were the Top 3 Pick Up Locations for 2019-10-18?

QUERY:
select
cast(g.lpep_pickup_datetime as DATE),
sum(g.total_amount),
z."Zone"
from green_taxi_2019_10 g
left join zones z on g."PULocationID" = z."LocationID"
where cast(g.lpep_pickup_datetime as DATE) = '2019-10-18'
group by cast(g.lpep_pickup_datetime as DATE), z."Zone"
order by sum(g.total_amount) desc
;

RESULT:
East Harlem North, East Harlem South, Morningside Heights

Question #6 (Largest Tip):
For Passengers Picked Up in East Harlem North, Which Drop Off Location had the Largest Tip?

QUERY:
select
zpu."Zone" as "PickUp Zone",
zdo."Zone" as "DropOff Zone",
g."tip_amount"
from green_taxi_2019_10 g
left join zones zpu on g."PULocationID" = zpu."LocationID"
left join zones zdo on g."DOLocationID" =zdo."LocationID"
where zpu."Zone" = 'East Harlem North'
order by g."tip_amount" desc
;

RESULT:
JFK Airport (Tip of 87.3)

Question #7 (Terraform Workflow):
Which Describes the Workflow for Downloading the provider plugins and setting up backend, Generating proposed changes and auto-executing the plan, Remove all resources managed by terraform

ANSWER:
terraform init, terraform apply -auto-aprove, terraform destroy
