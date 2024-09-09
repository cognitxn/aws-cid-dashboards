resource "aws_cur_report_definition" "source" {
  provider = aws.us_east_1

  depends_on = [
    aws_s3_bucket_versioning.source,
    aws_s3_bucket_policy.source
  ]

  report_name                = "${var.resource_prefix}-${var.cur_name_suffix}"
  time_unit                  = "HOURLY"
  format                     = "Parquet"
  compression                = "Parquet"
  additional_schema_elements = var.enable_split_cost_allocation_data ? ["RESOURCES", "SPLIT_COST_ALLOCATION_DATA"] : ["RESOURCES"]
  s3_bucket                  = aws_s3_bucket.source.bucket
  s3_region                  = local.aws_region
  s3_prefix                  = "cur/${local.account_id}"
  additional_artifacts       = ["ATHENA"]
  report_versioning          = "OVERWRITE_REPORT"
  refresh_closed_reports     = true
}
