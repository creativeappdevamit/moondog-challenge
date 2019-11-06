provider "google" {
  region = var.region
  project = var.project
}

resource "google_composer_environment" "composer" {
  name = var.name
  region = var.region
  config {
    node_count = 3

    node_config {
      zone = var.zone
      machine_type = var.machine

      network = google_compute_network.composer-network.self_link
      subnetwork =  google_compute_subnetwork.composer-subnetwork.self_link

      service_account = google_service_account.composer-service-account.name
    }
    software_config {
      airflow_config_overrides = {
        core-load_example = "True"
      }
      python_version = 3
    }
  }

  depends_on = ["google_project_iam_member.composer-worker"]
}

resource "google_compute_network" "composer-network" {
  name          =  "${var.name}-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "composer-subnetwork" {
  name          = "${var.name}-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.composer-network.self_link
}

resource "google_service_account" "composer-service-account" {
  account_id   = "composer-env-account"
  display_name = "Service Account for Composer Environment"
}

resource "google_project_iam_member" "composer-worker" {
  role    = "roles/composer.worker"
  member  = "serviceAccount:${google_service_account.composer-service-account.email}"
}

resource "google_project_iam_member" "big-query-job-user" {
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.composer-service-account.email}"
}

resource "google_bigquery_dataset" "bigquery" {
  dataset_id                  = "dogecoin"
  description                 = "This dataset will comprise of dogecoin data"
  default_table_expiration_ms = var.table_expiry

  labels = {
    env = "default"
  }
}

resource "google_bigquery_table" "bigquery-table" {
  dataset_id = google_bigquery_dataset.bigquery.dataset_id
  table_id   = "dogecoin_bucket_table"

  labels = {
    env = "default"
  }

  schema = file("${path.module}/bigquery_table_schema.json")
}

resource "local_file" "config" {
  content     = "[config]\nbucket = dogecoin_blocks\ndata_set = ${google_bigquery_table.bigquery-table.project}.${google_bigquery_table.bigquery-table.dataset_id}.${google_bigquery_table.bigquery-table.table_id}"
  filename = "${path.root}/../airflow/config/config_dc.ini"
  depends_on = [google_bigquery_table.bigquery-table]
}