resource "aws_cloudfront_origin_access_control" "cloudfront_access_control" {
    name = "cloudfront access control"
    description = "Access for S3 bucket"
    origin_access_control_origin_type = "s3"
    signing_behavior = "always"
    signing_protocol = "sigv4"
}


resource "aws_cloudfront_distribution" "cloudfront_distribution" {

  depends_on = [ aws_acm_certificate_validation.certificate_validation ]

  origin {
    domain_name              = aws_s3_bucket.domain_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_access_control.id
    origin_id                = "website-origin"
  }

  enabled             = true
  default_root_object = "index.html"

  logging_config {
    include_cookies = true
    bucket          = "${aws_s3_bucket.logs_domain_bucket.id}.s3.amazonaws.com"
    prefix          = "logs/"
  }

  aliases = [var.domain_name, var.subdomain_name]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "website-origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }


  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.certificate_request.arn
    minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method = "sni-only"
  }
}