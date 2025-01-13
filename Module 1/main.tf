# GOOGLE PROVIDER

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.15.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)
  project = var.project
  region = var.region
}

# GOOGLE STORAGE BUCKET

resource "google_storage_bucket" "demo-bucket" {
  name          = var.gcs_bucket_name
  location      = var.location
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

# UPLOADING DATASET
resource "google_bigquery_dataset" "demo_dataset" {
  dataset_id = var.bq_dataset_name
  location = var.location
}

#TERMINAL RUN:
# 1. terraform init
# 2. terraform plan (after adding storage bucket part)
# 3. terraform apply
# 4. terraform destroy (if done with everything and don't need it anymore)
