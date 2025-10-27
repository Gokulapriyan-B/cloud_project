output "cluster_name" {
  value = google_dataproc_cluster.hadoop_cluster.name
}

output "master_instance_name" {
  value = google_dataproc_cluster.hadoop_cluster.cluster_config[0].master_config[0].instance_names[0]
}

output "staging_bucket" {
  value = google_storage_bucket.dataproc_staging.name
}

output "output_bucket" {
  value = google_storage_bucket.hadoop_output.name
}
