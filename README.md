# CHECK-IN APPLICATION

This terraform setup is used to setup the infrastructure
for a dockerised check-in python flask application running on ECS with Fargate


### Pre-requisite
- Ensure the below are installed

```````````
AWS CLI
Docker
Terraform
Python3
```````````

### Steps

1. Clone the `checkin-olu` repo:  
```````````
git clone https://github.com/Olu180/checkin-olu.git
```````````

1. Change Directory to checkin-olu
```````````
cd checkin-olu
```````````

1. (Optional) Edit the `backend.tf` for s3 backend file

1. Initialise the working directory containing Terraform configuration files
```````````
terraform init
```````````

1. Create the ecr image repositories for the frontend and backend app.
```````````
terraform plan -target="module.ecr"
terraform apply -target="module.ecr"
```````````

1. Push the docker image into the ecr repositories.

    - Change directory to the backend app and build the docker image using the following command
    ```````````
    cd app/backend
    docker build -t check-in-app-backend .
    ```````````

    - After the build is completed, tag your image so you can push the image to this repository:
    ```````````
    docker tag check-in-app-backend:latest 904443750401.dkr.ecr.eu-west-2.amazonaws.com/check-in-app-backend:latest
    ```````````

    - Retrieve an authentication token and authenticate your Docker client to your registry.
    ```````````
    aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 904443750401.dkr.ecr.eu-west-2.amazonaws.com
    ```````````

    - Run the following command to push this image to your newly created AWS repository:
    ```````````
    docker push 904443750401.dkr.ecr.eu-west-2.amazonaws.com/check-in-app-backend:latest
    ```````````


    - Change directory to the frontend app and build the docker image using the following command
    ```````````
    cd ../app/frontend
    docker build -t check-in-app-frontend .
    ```````````

    After the build is completed, tag your image so you can push the image to this repository:
    ```````````
    docker tag check-in-app-frontend:latest 904443750401.dkr.ecr.eu-west-2.amazonaws.com/check-in-app-frontend:latest
    ```````````

    Run the following command to push this image to your newly created AWS repository:
    ```````````
    docker push 904443750401.dkr.ecr.eu-west-2.amazonaws.com/check-in-app-frontend:latest
    ```````````


1. Run terraform plan & apply
```````````
terraform plan
terraform apply
```````````


Output - `frontend-alb-dns`


## Future work for production

- Deploy a remote backend resoures
- Configure SSL for ALBs
- Use custom key for Dynamodb table
- Create a CI/CD pipeline github action
- Increase the `desired_count` for both Backend and Frontend
- Create an entry in Route 53 to point the PRD domain to the frontend alb dns
