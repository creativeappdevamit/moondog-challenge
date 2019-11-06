# Intro
This project spins up required components to copy data from google cloud storage to google big query for a specific 
challenge.

This project utilises GCP managed workflow orchestration service built on Apache Airflow to copy data from a specific 
public gcs bucket to the project's bigquery table on a scheduled interval.

## Infrastructure/Environment Setup

### pre-requisite : 
>- Ensure Terraform 0.12 is installed
>- Ensure appropriate permission and access on gcp cloud console project.
>- google cloud sdk is installed and configuration is properly setup.

**NOTE** - This project uses GCS backend for state management, please insure you replace `bucket` variable in 
`terraform/terraform.tf` with your own GCS bucket name.

### Terraform Resources
Terraform script will create following three main resources on GCP
>- composer environment
>- bigquery table 
>- service account 
 
### Usage
- run `terraform plan` to plan your resource deployment.
- run `terraform apply` to commit to your resource deployment.
- once `terraform apply` will commit the resources to your console project it will also create a configuration file for airflow dag deployment. 
- Run following command from root project:

```gsutil -m cp -r airflow/* {composer_dag_bucket value} ``` 

>  {composer_dag_bucket} will be the output of the terraform script ex. ` gs://europe-west2-composer-env-XXX-bucket/dags
`
