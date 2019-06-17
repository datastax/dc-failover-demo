# Provisioning and deployment files for Multi DC failover demo

Terraform configurations for provisioning:

- 6 EC2 instances for [DataStax Distribution of Apache Cassandra][ddac] nodes segregated in two data-centers:
    - Region us-east-1: 3 `m5.2xlarge` instances across 3 Availability Zones (AZ). 
    - Region us-west-1: 3 `m5.2xlarge` instances across 3 AZs.
- 6 EC2 `m5.large` instances to be used for application services, one in each AZ.
- 2 EC2 instances (size?) to be used as clients, one in each region. 
- 2 ELB, one per region, with health checks enabled.
- 1 AWS Global Accelerator as a ELB anycast frontend (Terraform support [in progress][terraform_aws_ga]).

## Packer images

Apache Cassandra and microservices software are deployed using two different pre-built Packer images.

## Using AWS Okta

In order to authenticate with AWS using your Okta credentials, you must install [aws-okta][aws-okta] vault tool.

You can prefix your terraform and packer commands with `aws-okta exec <profile> -- <my_cmd>`, for example:

```bash
aws-okta exec eng -- terraform apply
```

Where `eng` is the name of the AWS profile created with `aws-okta`.

## Building images and provisioning

Initialize the terraform environment:

```bash
terraform init ./terraform/
```

Build the images:

```bash
aws-okta exec <profile> -- packer build ./packer/template.json
```

Create the infrastructure and provisioning

```bash
aws-okta exec <profile> -- terraform apply ./terraform/
```

[ddac]: https://www.datastax.com/products/datastax-distribution-of-apache-cassandra
[terraform_aws_ga]: https://github.com/terraform-providers/terraform-provider-aws/pull/8328
[aws-okta]: https://github.com/segmentio/aws-okta