resource "aws_route53_record" "alb_route53_record" {
  depends_on = [ kubernetes_ingress_v1.flask_ingress ]
  zone_id  = data.aws_route53_zone.test-domain.zone_id
  name     = "flask.neon.markets"
  type     = "CNAME"
  ttl      = "60"
  records  = [data.aws_lb.flask-alb.dns_name]
  provider = aws.route53
}