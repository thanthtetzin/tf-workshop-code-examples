variable "region" {
  type    = string
  description = "The region to deploy the bucket to"

  validation {
    condition = contains(["eu-central-1", "eu-west-3"], var.region)
    error_message = "region is invalid, only allowed regions are: 'eu-central-1', 'eu-west-3'"
  }
  nullable = false
}

variable "owner" {
  type    = string
  nullable = false
}

variable "purpose" {
  type    = string
  default = "BO platform Terraform Basic Features Workshop"
}

variable "name" {
  type    = string
  description = "name will genearate as the format: tf-workshop-$var_owner-$var_name-$random_num"
  nullable = false
}
