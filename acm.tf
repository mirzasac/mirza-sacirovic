# #AWS Certificate Manager
# resource "aws_acm_certificate" "mirzasa-com" {
#   domain_name = "mirzasa.com"
#   subject_alternative_names = [
#       "*.mirzasa.com"
#   ]
#   validation_method = "DNS"
# }
# #Cert Validation Route 53 Records
# resource "aws_route53_record" "mirzasa-cert-validation-records" {
#   name = "${aws_acm_certificate.mirzasa-com.domain_validation_options.0.resource_record_name}"
#   type = "${aws_acm_certificate.mirzasa-com.domain_validation_options.0.resource_record_type}"
#   zone_id = "${aws_route53_zone.mirzasa.zone_id}"
#   records = [
#       "${aws_acm_certificate.mirzasa-com.domain_validation_options.0.resource_record_value}"
#   ]
#   ttl = 60
# }
# #Cert Validation
# resource "aws_acm_certificate_validation" "mirzasa-cert-validation" {
#   certificate_arn = "${aws_acm_certificate.mirzasa-com.arn}"
#   validation_record_fqdns = [
#       "${aws_route53_record.mirzasa-cert-validation-records.fqdn}"
#   ]
# }