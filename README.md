# Cloud Resume

This project showcases the use of some AWS services to deploy a resume website.
It integrates S3, Route 53, ACM, CloudFront, API Gateway, Lambda functions, DynamoDB and Terraform.


## Features

- **Static Website Hosting:** Hosted in an S3 bucket using the Static Website Hosting feature
- **Custom Domain:** Uses Route 53  for managing domain names and records
- **Infrastructure as Code:** Manages the AWS resources programmatically using Terraform
- **Backend:** Serverless backend built with API Gateway, Lambda functions and DynamoDB
- **Visit Counter:** Tracks how many times people have visited the site
- **CI/CD Pipeline:** Github Actions automates the process of deployment
- **CloudWatch:** Logs metrics for API Gateway and Lambda


## Architecture

The architecture looks like this:

![Architecture diagram](architecture.png)



## Future Improvements

- [x]  Add a visitor counter to the site
- [x]  Implement a CI/CD pipeline to enhance the development process
- [ ]  Add a weakly/monthly visit counter
