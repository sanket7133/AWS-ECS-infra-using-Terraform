# Terraform-Project
![diagram-export-28-07-2024-12_00_07](https://github.com/user-attachments/assets/6b12808a-d3f9-4c31-9d12-44c141b225a8)

The image depicts the infrastructure for deploying a Node.js application on AWS using Terraform.

The workflow begins with Terraform, which acts as the configuration management tool for the entire deployment.

## Terraform creates and manages the following components:

### VPC Group:
This is the foundation of the infrastructure, a virtual network that hosts all the other resources. It includes three subnets: Subnet 1, Subnet 2 and Subnet 3.
### ECR (Elastic Container Registry):
Used to store the Docker image containing the Node.js application code.
ECS Cluster: 
A container orchestration service that manages the deployment and scaling of containers.
### ECS Service:
Within the ECS Cluster, an ECS Service is created to run the Node.js application container. This service uses the Docker image from ECR.
### Load Balancer: 
This distributes incoming traffic to the ECS Service across multiple instances, ensuring high availability and scalability.
The deployment workflow also includes integration with Jenkins:

### Jenkins Server: Used for continuous integration and continuous deployment (CI/CD).
### Docker:
A containerization platform used to build and run the Node.js application as a Docker image. Jenkins interacts with Docker to build the image and push it to ECR.

Once the image is built and pushed to ECR, the ECS service deploys these containers and scales them according to demand. The Load Balancer directs traffic to the service, providing access to the Node.js application.

The final component is the Node Application itself, which users can access through the Load Balancer.

This architecture showcases a common approach for deploying Node.js applications on AWS using Terraform, ensuring a secure, scalable, and automated deployment process.

