Module #1: Docker, Postgres, & Terraform

----------- HOMEWORK -------------

Question #1 (Bash Commands):
docker --help
docker build --help
docker run --help

What Sub Command Removes One or More Images?
docker rmi

Question #2 (Docker First Run):
winpty docker run -it --entrypoint=bash python:3.12.8
pip --version
pip 24.3.1


Question #3 (Cound Records):
How Many Trips Were Made on October 18th, 2019?

QUERY:
select 
cast(lpep_pickup_datetime as date) as "PU_Date",
cast(lpep_dropoff_datetime as date) as "DO_Date",
count(1)
from green_taxi_2019_10
where cast (lpep_pickup_datetime as DATE) = '2019-10-18'
and cast(lpep_dropoff_datetime as DATE) = '2019-10-18'
group by 
cast(lpep_pickup_datetime as date),
cast(lpep_dropoff_datetime as date)
;

RESULT:
17417

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

Question #7 (Creating Resources):
Create Resources in GCP with Terraform
Run terraform apply and paste the results.

terraform apply

RESULTS:

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # google_bigquery_dataset.demo_dataset will be created
  + resource "google_bigquery_dataset" "demo_dataset" {
      + creation_time              = (known after apply)
      + dataset_id                 = "demo_dataset"
      + default_collation          = (known after apply)
      + delete_contents_on_destroy = false
      + effective_labels           = {
          + "goog-terraform-provisioned" = "true"
        }
      + etag                       = (known after apply)
      + id                         = (known after apply)
      + is_case_insensitive        = (known after apply)
      + last_modified_time         = (known after apply)
      + location                   = "US"
      + max_time_travel_hours      = (known after apply)
      + project                    = "sunlit-precinct-447121-u1"
      + self_link                  = (known after apply)
      + storage_billing_model      = (known after apply)
      + terraform_labels           = {
          + "goog-terraform-provisioned" = "true"
        }

      + access (known after apply)
    }

  # google_storage_bucket.demo-bucket will be created
  + resource "google_storage_bucket" "demo-bucket" {
      + effective_labels            = {
          + "goog-terraform-provisioned" = "true"
        }
      + force_destroy               = true
      + id                          = (known after apply)
      + location                    = "US"
      + name                        = "sunlit-precinct-447121-u1-terraform-bucket"
      + project                     = (known after apply)
      + project_number              = (known after apply)
      + public_access_prevention    = (known after apply)
      + rpo                         = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + terraform_labels            = {
          + "goog-terraform-provisioned" = "true"
        }
      + uniform_bucket_level_access = (known after apply)
      + url                         = (known after apply)

      + lifecycle_rule {
          + action {
              + type          = "AbortIncompleteMultipartUpload"
                # (1 unchanged attribute hidden)
            }
          + condition {
              + age                    = 1
              + matches_prefix         = []
              + matches_storage_class  = []
              + matches_suffix         = []
              + with_state             = (known after apply)
                # (3 unchanged attributes hidden)
            }
        }

      + soft_delete_policy (known after apply)

      + versioning (known after apply)

      + website (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
