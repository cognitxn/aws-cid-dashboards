variable "cur_name_suffix" {
  default     = "cur"
  description = "Suffix used to name the CUR report."
  type        = string
}

variable "destination_bucket_arn" {
  type        = string
  description = "ARN of bucket where objects will be replicated."
}

variable "enable_force_destroy" {
  default     = true
  description = <<-EOF
    Indicates all objects (including any locked objects) should be deleted from the
    bucket when the bucket is destroyed.
  EOF
  type        = bool
}

variable "enable_split_cost_allocation_data" {
  default     = false
  description = "Enable split cost allocation data for ECS and EKS for this CUR report."
  type        = bool
}

variable "noncurrent_version_expiration" {
  default     = 32
  description = "The number of days a noncurrent object is stored before it is expired."
  type        = number
}

variable "object_expiration_days" {
  default     = 64
  description = "The number of days an object is stored before it is expired."
  type        = number
}

variable "resource_prefix" {
  description = "Prefix used for all named resources, including the S3 Bucket."
  type        = string
}

variable "s3_access_logging" {
  type = object({
    enabled = bool
    bucket  = string
    prefix  = string
  })
  description = "S3 Access Logging configuration for the CUR bucket"
  default = {
    enabled = false
    bucket  = null
    prefix  = null
  }
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to apply to module resources."
}
