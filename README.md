# Dockerized Disk Monitoring & Automated EC2 Deployment

## Project Overview

This project demonstrates a simple DevOps CI/CD pipeline that automatically builds a Docker image, pushes it to Amazon ECR, and deploys the image to an Amazon EC2 instance using AWS Systems Manager (SSM).

The Docker container runs a Bash script that checks the root filesystem disk usage and reports whether the usage is normal or above the defined threshold.

## Architecture

```text
Developer
    |
    v
GitHub Repository
    |
    v
GitHub Actions
    |
    +--> Docker Build
    |
    +--> Push Image
    |
    v
Amazon ECR
    |
    v
AWS Systems Manager (SSM)
    |
    v
Amazon EC2
    |
    v
Docker Container
    |
    v
Disk Monitoring Script
```

## Technologies Used

* Git & GitHub
* GitHub Actions
* Docker
* Amazon ECR
* Amazon EC2
* AWS Systems Manager (SSM)
* AWS IAM
* Bash Shell Scripting
* Ubuntu Linux

## Project Workflow

### 1. Source Code

The application source code and Docker configuration are maintained in GitHub.

### 2. GitHub Actions

Whenever code is pushed to the `main` branch, GitHub Actions automatically starts the CI/CD workflow.

The workflow:

1. Checks out the source code.
2. Configures AWS credentials.
3. Authenticates with Amazon ECR.
4. Builds the Docker image.
5. Pushes the image to Amazon ECR.
6. Uses AWS Systems Manager to deploy the latest image to EC2.

### 3. Docker

The project uses an Ubuntu 22.04 base image.

The Dockerfile copies the disk monitoring script into the container and executes it when the container starts.

### 4. Disk Monitoring Script

The Bash script checks the disk usage of the root filesystem.

* If disk usage is above 80%, it displays a warning.
* Otherwise, it displays that disk usage is normal.

Example output:

```text
Disk usage is normal (Current: 51%)
```

### 5. Amazon ECR

The Docker image is stored in Amazon Elastic Container Registry (ECR).

Image repository:

```text
236087862934.dkr.ecr.ap-south-1.amazonaws.com/devops-project
```

### 6. Amazon EC2

AWS Systems Manager sends the deployment commands to the EC2 instance.

The EC2 instance:

1. Removes the previous container.
2. Authenticates with Amazon ECR.
3. Pulls the latest Docker image.
4. Creates a new Docker container.
5. Runs the disk monitoring script.

## IAM

An IAM user is used by GitHub Actions to authenticate with AWS.

The required permissions include:

* Amazon ECR authentication and image push permissions
* AWS Systems Manager `ssm:SendCommand`
* Required EC2/SSM access

## Dockerfile

```dockerfile
FROM ubuntu:22.04

COPY disk-check.sh /disk-check.sh

RUN chmod +x /disk-check.sh

CMD ["/disk-check.sh"]
```

## Disk Monitoring Script

```bash
#!/bin/bash

USAGE=$(df -h / | awk 'NR==2{print $5}' | sed 's/%//')

if [ $USAGE -gt 80 ]; then
    echo "Warning: Disk usage is above 80% (Current: $USAGE%)"
else
    echo "Disk usage is normal (Current: $USAGE%)"
fi
```

## Deployment Result

The complete pipeline successfully performs:

```text
GitHub
   ↓
GitHub Actions
   ↓
Docker Build
   ↓
Amazon ECR
   ↓
AWS SSM
   ↓
Amazon EC2
   ↓
Docker Container
   ↓
Disk Monitoring
```

## Key DevOps Concepts Practiced

* Git version control
* CI/CD automation
* Docker image creation
* Containerization
* Amazon ECR
* AWS IAM permissions
* AWS Systems Manager
* EC2 deployment
* Bash scripting
* Automated application deployment

## Project Outcome

This project demonstrates how a Dockerized workload can be automatically built, stored in Amazon ECR, and deployed to an EC2 instance through a GitHub Actions CI/CD pipeline using AWS Systems Manager.
