provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "~/.aws/credentials"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route_table" "route-table-us-east-2" {
    vpc_id = "${aws_vpc.main.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "Public Subnet route table"
    }
}

resource "aws_subnet" "main-subnet-public-2a" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  tags {
    Name = "public subnet 2a"
  }
}

resource "aws_subnet" "main-subnet-public-2b" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2b"
  tags {
    Name = "public subnet 2b"
  }
}

resource "aws_subnet" "main-subnet-public-2c" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-2c"
  tags {
    Name = "public subnet 2c"
  }
}

resource "aws_subnet" "main-subnet-private-2a" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-2a"
  tags {
    Name = "private subnet 2a"
  }
}

resource "aws_subnet" "main-subnet-private-2b" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.5.0/24"
  availability_zone = "us-east-2b"
  tags {
    Name = "private subnet 2b"
  }
}

resource "aws_subnet" "main-subnet-private-2c" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.6.0/24"
  availability_zone = "us-east-2c"
  tags {
    Name = "private subnet 2c"
  }
}

resource "aws_eip" "proxy_ip-1" {
  vpc = true
}

resource "aws_eip" "proxy_ip-2" {
  vpc = true
}

resource "aws_eip" "proxy_ip-3" {
  vpc = true
}

resource "aws_nat_gateway" "us-east-2a" {
  subnet_id = "${aws_subnet.main-subnet-public-2a.id}"
  allocation_id = "${aws_eip.proxy_ip-1.id}"
}

resource "aws_nat_gateway" "us-east-2b" {
  subnet_id = "${aws_subnet.main-subnet-public-2b.id}"
  allocation_id = "${aws_eip.proxy_ip-2.id}"
}

resource "aws_nat_gateway" "us-east-2c" {
  subnet_id = "${aws_subnet.main-subnet-public-2c.id}"
  allocation_id = "${aws_eip.proxy_ip-3.id}"
}

resource "aws_route_table" "route-table-us-east-2a-private" {
    vpc_id = "${aws_vpc.main.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.us-east-2a.id}"
    }

    tags {
        Name = "Private Subnet route table"
    }
}

resource "aws_route_table" "route-table-us-east-2b-private" {
    vpc_id = "${aws_vpc.main.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.us-east-2b.id}"
    }

    tags {
        Name = "Private Subnet route table"
    }
}

resource "aws_route_table" "route-table-us-east-2c-private" {
    vpc_id = "${aws_vpc.main.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.us-east-2c.id}"
    }

    tags {
        Name = "Private Subnet route table"
    }
}

resource "aws_route_table_association" "route-table-association-private-2a" {
    subnet_id = "${aws_subnet.main-subnet-private-2a.id}"
    route_table_id = "${aws_route_table.route-table-us-east-2a-private.id}"
}

resource "aws_route_table_association" "route-table-association-private-2b" {
    subnet_id = "${aws_subnet.main-subnet-private-2b.id}"
    route_table_id = "${aws_route_table.route-table-us-east-2b-private.id}"
}

resource "aws_route_table_association" "route-table-association-private-2c" {
    subnet_id = "${aws_subnet.main-subnet-private-2c.id}"
    route_table_id = "${aws_route_table.route-table-us-east-2c-private.id}"
}

resource "aws_route_table_association" "route-table-association-2a" {
    subnet_id = "${aws_subnet.main-subnet-public-2a.id}"
    route_table_id = "${aws_route_table.route-table-us-east-2.id}"
}

resource "aws_route_table_association" "route-table-association-2b" {
    subnet_id = "${aws_subnet.main-subnet-public-2b.id}"
    route_table_id = "${aws_route_table.route-table-us-east-2.id}"
}

resource "aws_route_table_association" "route-table-association-2c" {
    subnet_id = "${aws_subnet.main-subnet-public-2c.id}"
    route_table_id = "${aws_route_table.route-table-us-east-2.id}"
}
