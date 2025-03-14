resource "aws_acm_certificate" "certificate_request" {
  provider = aws.east
  domain_name = var.domain_name
  subject_alternative_names = [ var.subdomain_name ]
  validation_method = "DNS"


  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_acm_certificate_validation" "certificate_validation" {
  provider = aws.east
  certificate_arn         = aws_acm_certificate.certificate_request.arn
  validation_record_fqdns = [for record in aws_route53_record.validation_record : record.fqdn]
}

