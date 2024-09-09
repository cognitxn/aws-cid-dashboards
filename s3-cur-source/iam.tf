resource "aws_iam_role" "replication" {
  assume_role_policy    = data.aws_iam_policy_document.s3_assume_role.json
  force_detach_policies = true
  name_prefix           = "${var.resource_prefix}-replication"
  path                  = "/"

  tags = merge(
    var.tags,
    {
      Name = "${var.resource_prefix}-replication"
    }
  )
}

resource "aws_iam_policy" "replication" {
  name_prefix = "${var.resource_prefix}-replication"
  policy      = data.aws_iam_policy_document.replication.json
  tags = merge(
    var.tags,
    {
      Name = "${var.resource_prefix}-replication"
    }
  )
}

resource "aws_iam_policy_attachment" "replication" {
  name       = "${var.resource_prefix}-replication"
  policy_arn = aws_iam_policy.replication.arn
  roles      = [aws_iam_role.replication.name]
}
