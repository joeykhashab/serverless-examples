resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = ["${aws_subnet.main-subnet-private-2a.id}", "${aws_subnet.main-subnet-private-2b.id}","${aws_subnet.main-subnet-private-2c.id}"]

  tags {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "internal-sg" {
  name        = "internal-vpc-sg"
  description = "Allow all traffic from the VPC"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.main.cidr_block}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7.19"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "bar12345"
  db_subnet_group_name = "${aws_db_subnet_group.default.id}"
  skip_final_snapshot =  true
  vpc_security_group_ids = ["${aws_security_group.internal-sg.id}"]
}
