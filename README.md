# AWS for Data Day Milan 2023-Q1

This repository includes the infrastructure as code for deploying in you AWS account the solution reviewed at the "AWS for data" event in Milan, March 2023

## Getting started

### Prerequisites
In order to deploy this solution you need:
* An AWS Account
* Amazon QuickSights Active in your account
* Chosse an AWS Region where you want to deploy the solution (we suggest eu-west-1)
* Create a KeyPair

# Deploy

* Access your AWS Account
* From the CloudFormation console, deploy the 'aws-for-data-lab.yaml' template
* The template will create all the components of the architecture. It will also create and EC2 Bastion host and uses it to automatically create the database schemas for both the Amazon Aurora database and Amazon Redshift data warehouse