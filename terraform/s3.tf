resource "aws_s3_bucket" "domain_bucket" {
  bucket = var.domain_bucket

  tags = {
    Name        = var.domain_bucket
    Environment = "Prod"
  }
}

resource "aws_s3_bucket" "subdomain_bucket" {
  bucket = var.subdomain_bucket

  tags = {
    Name        = var.subdomain_bucket
    Environment = "Prod"
  }
}


resource "aws_s3_bucket" "logs_domain_bucket" {
  bucket = var.logs_domain_bucket

  tags = {
    Name        = var.logs_domain_bucket
    Environment = "Prod"
  }
}

resource "aws_s3_bucket_ownership_controls" "logs_domain_bucket_ownership" {
  bucket = aws_s3_bucket.logs_domain_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_website_configuration" "domain_bucket_website_config" {
  bucket = aws_s3_bucket.domain_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_website_configuration" "subdomain_bucket_website_config" {
  bucket = aws_s3_bucket.subdomain_bucket.id

  redirect_all_requests_to {
    host_name = var.domain_name
    protocol = "https"
  }

}


resource "aws_s3_object" "logs_prefix" {
  bucket = aws_s3_bucket.logs_domain_bucket.id
  key    = "logs/"
}

resource "aws_s3_bucket_logging" "logging_confiig" {
  bucket = aws_s3_bucket.domain_bucket.id

  target_bucket = aws_s3_bucket.logs_domain_bucket.id
  target_prefix = "logs/"
}



resource "aws_s3_bucket_public_access_block" "domain_bucket_public_access_config" {
  bucket = aws_s3_bucket.domain_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_access_policy" {
  bucket = aws_s3_bucket.domain_bucket.id
  policy = templatefile("s3-policy.json", { bucket = var.domain_bucket })
}

resource "aws_s3_object" "upload_frontend_files" {
    bucket = "s3://${var.domain_bucket}"
    for_each = fileset("frontend/", "**/*.*")

    key = each.value
    content_type = each.value.content_type
    source = "frontend/${each.value}"
}


