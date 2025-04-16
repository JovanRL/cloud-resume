resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}

/* resource "aws_route53domains_domain" "jovan_cloud" {
  domain_name = var.domain_name
  duration_in_years = 1
  auto_renew  = false
  admin_privacy      = true
  tech_privacy       = true

  name_server {
    name = aws_route53_zone.hosted_zone.primary_name_server
  }

  admin_contact {
    country_code      = "MX"
    state = "SI"
    zip_code = "80020"
    city = "Culiacan"
    address_line_1 = "Obregon"
    email             = var.email
    first_name        = "Jovan"
    last_name         = "Lopez"
    phone_number      = var.phone_number
    contact_type = var.contact_type
  }

  tech_contact {
    country_code      = "MX"
    email             = "jovanrlr@gmail.com"
    first_name        = "Jovan"
    last_name         = "Lopez"
    state = "SI"
    phone_number = var.phone_number
    contact_type = var.contact_type
    city = "Culiacan"
    address_line_1 = "Obregon"
    zip_code = "80020"
  }


  registrant_contact {
    country_code      = "MX"
    state = "SI"
    city = "Culiacan"
    address_line_1 = "Obregon"
    zip_code = "80020"
    email             = var.email
    first_name        = "Jovan"
    last_name         = "Lopez"
    phone_number = var.phone_number
    contact_type = var.contact_type
  }

  billing_contact {
    country_code = "MX"
    state = "SI"
    city = "Culiacan"
    zip_code = "80020"
    address_line_1 = "Obregon"
    first_name = "Jovan"
    last_name = "Lopez"
    email = var.email
    phone_number = var.phone_number
    contact_type = var.contact_type
  }

  tags = {
    Environment = "prod"
  }
} */


resource "aws_route53_record" "validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.certificate_request.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name = each.value.name
  records = [each.value.record]
  ttl = var.ttl
  type = each.value.type
  zone_id = aws_route53_zone.hosted_zone.zone_id
}


resource "aws_route53_record" "record_jovan_cloud" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = ""
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.cloudfront_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "subrecord_jovan_cloud" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = "www"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.cloudfront_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}


resource "aws_route53_record" "validation_record_api" {
  for_each = {
    for dvo in aws_acm_certificate.certificate_request_api.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name = each.value.name
  records = [each.value.record]
  ttl = var.ttl
  type = each.value.type
  zone_id = data.aws_route53_zone.public.zone_id
}