resource "aws_route53_zone" "main" {
  name = "serverless-examples.net"
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route53_record" "dev-ns" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name = "database.serverless-examples.net"
  type = "CNAME"
  ttl = "300"
  records = ["${aws_db_instance.default.address}"]
}
