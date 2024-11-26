region = "eu-west-1"
aws_iam_role_arn = "arn:aws:iam::972156694227:role/app-shared-role"
aws_iam_role_arn_route53 = "arn:aws:iam::189667852982:role/app-shared-role"
app_name = "flask"

image = "ghcr.io/boxisun/python-docker-eks"
image_version = "0.0.1"

num_of_replicas = 2

tags = {
  terraform = "true"
  project = "flask"
}
