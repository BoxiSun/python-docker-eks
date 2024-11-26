# python-docker-eks

Cloud provider: AWS

Prerequisite:
1. An IAM user with the permission to assume an IAM role (arn:aws:iam::972156694227:role/app-shared-role)
2. The IAM role "arn:aws:iam::972156694227:role/app-shared-role" with the permission to deploy all the required AWS resources
Note: Step 2 below requires another role with the same name in another AWS account. The IAM user should also be able to assume that role.
3. Clone the repo to your local computer (git clone https://github.com/BoxiSun/python-docker-eks.git)
4. HTTPS certificate requires a owned domain. I am using one of the company owned privated hosted zones for ingress controller 

Step 1 - Create the terraform backend S3 bucket and Dynamodb table (the terraform backend used by EKS cluster and the flask app)
1. cd tf-s3-backend
2. terraform init
3. terraform plan --var-file=config.tfvars
4. terraform apply --var-file=config.tfvars
5. configure "../config/config.tfbackend" accordingly (make sure the values of "bucket" and "dynamodb_table" are correct)
6. configure "../provider.tf" accordingly (add "backend "s3" {}")

Step 2 - Create a SSL certificate in AWS certificate manager for EKS ingress
1. cd acm_certificate
2. terraform init
3. terraform plan --var-file=config.tfvars
4. terraform apply --var-file=config.tfvars
5. cd ../flask-app-deployment
6. Fill in the certificate domain name to the value of "domain" in line 4 of data.tf. It will be used as the HTTPS certificate by EKS ingress

Step 3 - Create the VPC and the EKS cluster
1. cd .. (the root of "python-docker-eks")
2. terraform init -reconfigure --backend-config=config/config.tfbackend
3. terraform plan --var-file=config/config.tfvars
4. terraform apply --var-file=config/config.tfvars

Step 4 - Build the python flask docker image
1. cd flask-docker
2. openssl req -x509 -newkey rsa:4096 -nodes -out cert.pem -keyout key.pem -days 30
3. docker build --tag ghcr.io/boxisun/python-docker-eks:0.0.1 .
4. docker login --username BoxiSun --password <personal access token> ghcr.io
5. docker push ghcr.io/boxisun/python-docker-eks:0.0.1
6. (optional) follow the steps in the article below to create a secret for image pulling if the image is marked "private"
    https://dev.to/asizikov/using-github-container-registry-with-kubernetes-38fb
7. (optional) find an example yaml file from "../EKS manifests/dockerconfigjson.yaml", run "kubectl apply -f dockerconfigjson.yaml" before the next step
Note: I've marked the image "public", therefore 6 and 7 are not required.

Step 5 - Deploy the flask app to the EKS cluster
1. cd ../flask-app-deployment
2. terraform init -reconfigure --backend-config=config/config.tfbackend
3. terraform plan --var-file=config/config.tfvars
4. terraform apply --var-file=config/config.tfvars

Step 6 - Destroy the flask app
1. cd flask-app-deployment (if you are at the root)
2. terraform destroy --var-file=config/config.tfvars

Step 7 - Destory the EKS cluster and VPC
1. cd .. (the root of "python-docker-eks")
2. terraform destroy --var-file=config/config.tfvars