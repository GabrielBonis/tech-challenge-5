locals {
  database_to_buckets = {
    "dl-raw-zone"      = aws_s3_bucket.buckets[0].bucket
    "dl-delivery-zone" = aws_s3_bucket.buckets[1].bucket
  }
}


resource "aws_glue_crawler" "glue_crawler" {
  count = length(var.database_names) # Cria um crawler para cada banco de dados

  name          = "${local.prefix}-${var.database_names[count.index]}-crawler"
  database_name = var.database_names[count.index]
  role          = aws_iam_role.glue_role.arn

  # Define os caminhos S3 fixos para cada banco de dados
  s3_target {
    path = "s3://${lookup(local.database_to_buckets, var.database_names[count.index])}/*"
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  configuration = jsonencode({
    Version = 1.0
    CrawlerOutput = {
      Partitions = { AddOrUpdateBehavior = "InheritFromTable" }
    }
  })

  tags = merge(
    local.common_tags
  )
}
