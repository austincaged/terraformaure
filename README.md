automated-php-deployment-with-terraform-ansible-docker-azure


This project involves setting up a CI/CD pipeline for a Dockerized PHP web application using Azure DevOps. The goal is to automate the process of building, testing, and deploying the application whenever code changes are made. Project Objectives

Automate Infrastructure Deployment: Use Terraform to provision cloud resources (VM, security groups, network, IPs).

Automate Server Configuration: Utilize Ansible to install Docker and configure SSH access.

Containerize the Application: Package the PHP web application in a Docker container for consistent deployment.

Set Up CI/CD Pipeline: Implement GitHub Actions to automate building, testing, and deployment.

Ensure Secure Access: Manage credentials securely and follow best security practices.


Technologies Used

Cloud Provider: Microsoft Azure

Infrastructure as Code (IaC): Terraform

Configuration Management: Ansible

Containerization: Docker

CI/CD Automation: GitHub Actions

Version Control: Git & GitHub

Programming Language: PHP and html/ css for styling. (for the web application)


Project Workflow

Infrastructure Setup

Terraform scripts create cloud resources (VM, security groups, networking).

Configuration Management.....

Ansible automates Docker installation and SSH key setup on the VM.

Application Containerization......

The Python web application is packaged as a Docker container.

CI/CD Pipeline Implementation

GitHub Actions triggers the deployment process upon each code commit.

The pipeline builds the Docker image, pushes it to Docker Hub, and deploys it on the Azure VM.

Installation & Usage


Prerequisites........

Ensure you have the following installed:

Terraform

Ansible

Docker & Docker Compose

Git

An active Azure account with necessary permissions


Deployment Steps.......

Clone the Repository:

git clone (https://github.com/austincaged/terraformaure)

Set Up Azure Credentials (for Terraform & Ansible):

Configure Azure CLI authentication:

az login

Store Azure service principal credentials securely.

Provision Infrastructure with Terraform:

terraform init terraform apply -auto-approve

Configure the Server with Ansible:

ansible-playbook -i inventory.yaml setup-docker.yml

Build and Push Docker Image:

docker build -t your-dockerhub-username/app-name . docker push your-dockerhub-username/app-name

Run the Application on the Server:

docker run -d -p 80:5000 your-dockerhub-username/app-name

Set Up GitHub Actions Workflow

Configure secrets in GitHub (Docker Hub credentials, Azure credentials).

Push code changes to trigger the pipeline.
