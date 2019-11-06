variable "project" {
  description = "The project ID to create the resources in."
  type        = string
}

variable "region" {
  description = "The region to create the resources in."
  default = "europe-west2"
  type        = string
}

variable "zone" {
  description = "The availability zone to create the sample compute instances in. Must within the region specified in 'var.region'"
  default = "europe-west2-a"
  type        = string
}

variable "name" {
  description = "Name for the composer environment."
  type        = string
  default     = "composer-env"
}

variable "machine" {
  description = "Machine type for the composer"
  type = string
  default = "n1-standard-1"
}

variable "table_expiry" {
  default = 3600000
}