locals {
  account_id  = data.aws_caller_identity.current.account_id
  aws_region  = data.aws_region.current.name
  bucket_name = "${var.resource_prefix}-${data.aws_caller_identity.current.account_id}-local"
  partition   = data.aws_partition.current.partition
  tags = merge(
    var.tags,
    {
      Name = local.bucket_name
    }
  )
}