output composer_environment {
  description = "The composer environment Id"
  value       = google_composer_environment.composer.id
}

output composer_config {
  description = "The composer environment configuration"
  value       = google_composer_environment.composer.config
}

output composer_service_account {
  description = "The service account for composer"
  value       = google_service_account.composer-service-account.account_id
}

output composer_dag_bucket {
  description = "The composer environment dag bucket"
  value       = google_composer_environment.composer.config[0].dag_gcs_prefix
}