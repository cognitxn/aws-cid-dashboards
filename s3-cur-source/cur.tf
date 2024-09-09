resource "aws_cur_report_definition" "source" {
  provider = aws.us_east_1

  depends_on = [
    aws_s3_bucket_versioning.source,
    aws_s3_bucket_policy.source
  ]

  additional_artifacts       = ["ATHENA"]
  additional_schema_elements = var.enable_split_cost_allocation_data ? ["RESOURCES", "SPLIT_COST_ALLOCATION_DATA"] : ["RESOURCES"]
  compression                = "Parquet"
  format                     = "Parquet"
  refresh_closed_reports     = true
  report_name                = "${var.resource_prefix}-${var.cur_name_suffix}"
  report_versioning          = "OVERWRITE_REPORT"
  s3_prefix                  = "cur/${local.account_id}"
  s3_bucket                  = aws_s3_bucket.source.bucket
  s3_region                  = local.aws_region
  tags = merge(
    var.tags,
    {
      Name = "${var.resource_prefix}-${var.cur_name_suffix}"
    }
  )
  time_unit = "HOURLY"
}
