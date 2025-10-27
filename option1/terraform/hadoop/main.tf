terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_dataproc_cluster" "hadoop_cluster" {
  name   = var.cluster_name
  region = var.region

  cluster_config {
    staging_bucket = google_storage_bucket.dataproc_staging.name

    master_config {
      num_instances = 1
      machine_type  = "n1-standard-2"
      disk_config {
        boot_disk_type    = "pd-standard"
        boot_disk_size_gb = 50
      }
    }

    worker_config {
      num_instances = 2
      machine_type  = "n1-standard-2"
      disk_config {
        boot_disk_type    = "pd-standard"
        boot_disk_size_gb = 50
      }
    }

    software_config {
      image_version = "2.1-debian11"
      optional_components = ["JUPYTER"]
    }

    gce_cluster_config {
      zone = "${var.region}-a"
      metadata = {
        "enable-oslogin" = "true"
      }
    }
  }
}

resource "google_storage_bucket" "dataproc_staging" {
  name          = "${var.project_id}-dataproc-staging"
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "hadoop_output" {
  name          = "${var.project_id}-hadoop-output"
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
}

