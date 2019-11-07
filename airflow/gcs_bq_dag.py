from __future__ import print_function

import datetime
import os

from airflow import models
from airflow.contrib.operators import gcs_to_bq
from airflow.operators import dummy_operator
import configparser

Today = datetime.datetime.now() - datetime.timedelta(hours=2)

default_dag_args = {
    'owner': 'airflow',
    'start_date': Today,
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': datetime.timedelta(minutes=5),
    'weight_rule': 'upstream'
}
config_parser = configparser.ConfigParser()
config_parser.read(os.path.join(os.path.split(__file__)[0], 'config/config.ini'))
config = config_parser['config']
data_set = config['data_set']
bucket = config['bucket']

with models.DAG(
        'dogecoin-block-example',
        schedule_interval=datetime.timedelta(minutes=60),
        catchup=False,
        default_args=default_dag_args) as dag:
    start = dummy_operator.DummyOperator(
        task_id='start',
        trigger_rule='all_success'
        )

    end = dummy_operator.DummyOperator(
        task_id='end',
        trigger_rule='all_success'
        )

    GCS_to_BQ = gcs_to_bq.GoogleCloudStorageToBigQueryOperator(
        task_id='GCS_to_BQ',
        bucket=bucket,
        source_objects=['*.csv'],
        destination_project_dataset_table=data_set,
        source_format='CSV',
        write_disposition='WRITE_TRUNCATE',
        autodetect=True
    )

    start >> GCS_to_BQ >> end
