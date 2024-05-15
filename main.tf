resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_b

}

resource "aws_subnet" "subnet_public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}


# resource "aws_subnet" "subnet_public2" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = "10.0.2.0/24"
#   availability_zone       = "ap-south-1b"
#   map_public_ip_on_launch = true
# }

resource "aws_internet_gateway" "IGW" {

  vpc_id = aws_vpc.vpc.id

  tags = {
    name = "IGW"
  }
}

resource "aws_route_table" "RT" {

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

resource "aws_route_table_association" "RTa1" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.RT.id
}

# resource "aws_route_table_association" "RTa2" {
#   subnet_id      = aws_subnet.subnet_public2.id
#   route_table_id = aws_route_table.RT.id
# }

resource "aws_security_group" "SG2" {
  name   = "SG1"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

   ingress {
    description = "jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    description = "Outbound "
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# resource "aws_s3_bucket" "s3" {
#   bucket = "sanketbucket-terraform"
# }

# resource "aws_s3_bucket_public_access_block" "example" {
#   bucket = aws_s3_bucket.s3.id

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }


# resource "aws_s3_bucket_acl" "buckerACl" {
# bucket = aws_s3_bucket.s3.id
# acl = "public-read"

# depends_on = [ aws_s3_bucket_public_access_block.example ]

# }

# resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
#   bucket = aws_s3_bucket.s3.id
#   rule {
#     object_ownership = "ObjectWriter"
#   }
# }

resource "aws_instance" "EC2a" {

  ami = "ami-0f58b397bc5c1f2e8"

  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.SG2.id]

  subnet_id = aws_subnet.subnet_public.id

  user_data = base64encode(file("jenkins.sh"))

  tags = {
    name = "jenkins"
  }

}

# resource "aws_instance" "EC2b" {

#   ami = "ami-0f58b397bc5c1f2e8"

#   instance_type = "t2.micro"

#   vpc_security_group_ids = [aws_security_group.SG.id]

#   subnet_id = aws_subnet.subnet_public2.id
#   user_data = base64encode(file("userdata2.sh"))
# }

# resource "aws_lb" "ALB" {

#   load_balancer_type = "application"
#   name               = "MyALB"
#   internal           = false
#   subnets            = [aws_subnet.subnet_public.id, aws_subnet.subnet_public2.id]
#   security_groups    = [aws_security_group.SG.id]

# }

# resource "aws_lb_target_group" "ALBtG" {

#   name     = "ALBtG"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.vpc.id

#   health_check {
#     path = "/"
#     port = "traffic-port"

#   }

# }

# resource "aws_lb_target_group_attachment" "ALB_attach" {
#   target_group_arn = aws_lb_target_group.ALBtG.arn
#   target_id        = aws_instance.EC2a.id
#   port             = 80

# }

# resource "aws_lb_target_group_attachment" "ALB_attach2" {
#   target_group_arn = aws_lb_target_group.ALBtG.arn
#   target_id        = aws_instance.EC2b.id
#   port             = 80
# }

# resource "aws_lb_listener" "listner" {
#   load_balancer_arn = aws_lb.ALB.arn
#   port              = 80
#   protocol          = "HTTP"
#   default_action {
#     target_group_arn = aws_lb_target_group.ALBtG.arn
#     type             = "forward"
#   }
# }

# output "DNS" {
#   value = aws_lb.ALB.dns_name
# }

resource "aws_ecr_repository" "ECR" {
  name                 = "projectrepo1"
  image_tag_mutability = "MUTABLE"
  

  image_scanning_configuration {
    scan_on_push = true
  }
}