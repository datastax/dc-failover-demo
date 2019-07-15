# Fault Tolerant Applications with DataStax and Apache Cassandra™ Demo

Demo project to provision and deploy a multitier application architecture that is resilient to infrastructure outages
at Availability Zone and Region level using DataStax and Apache Cassandra™.

This project contains the support files to provision the following instances and services on AWS:

- 6 EC2 instances for [DataStax Distribution of Apache Cassandra][ddac] nodes segregated in two data-centers:
    - Region us-east-1: 3 EC2 `m5.2xlarge` instances across 3 Availability Zones (AZ). 
    - Region us-west-2: 3 EC2 `m5.2xlarge` instances across 3 AZs.
- 6 EC2 `m5.large` instances to be used for application services, one in each AZ.
- 2 [ELB][elb], one per region, with health checks enabled.
- 1 [AWS Global Accelerator][gacc] as ELBs anycast frontend, with health checks enabled.
- 2 EC2 `t2.small` instances to be used as clients, one in each region. 

Note that regions used in this demo can be configured.

## Deployment diagram

![Deployment diagram](https://i.imgur.com/N2OKUZ2.png)

_Note that each web instance connects to all the Apache Cassandra nodes within the region, regardless of the AZ._

## Provisioning

### Packer images

Apache Cassandra, microservices and client software is deployed using three different pre-built [Packer][packer] images.

```bash
packer build ./packer/template.json
```

### Terraform

Infrastructure is created and provisioned using [Terraform][terraform].

```bash
terraform apply ./terraform/
```

### Verify

Terraform exports output values that are displayed after creating the infrastructure and provisioning.

These outputs are AWS Global Accelerator public IP addresses, load tester clients public IPs, bastion public IP and
temp private key to access the bastion.

Use one of the public ips of the Global Accelerator to access the service:

```bash
curl -i http://<accelerator_public_ip>/
```

## Using Packer and Terraform with AWS Vault / AWS Okta

If you have multiple AWS profiles, we recommend using a tool to manage those credentials, like
[AWS Vault][aws-vault], [AWS Okta][aws-okta]
(if you are using federated login with [Okta][okta]).

To create and deploy the infrastructure with AWS Vault, use:

```bash
aws-vault exec <profile_name> -- packer build ./packer/template.json
aws-vault exec <profile_name> -- terraform apply ./terraform/
```

With AWS Okta, use:

```bash
aws-okta exec <profile_name> -- packer build ./packer/template.json
aws-okta exec <profile_name> -- terraform apply ./terraform/
```

## Testing failover

### Simulate AZ outage

Remove the security group rule that allows internal TCP connections on Availability Zone 3 at Region 1.  

```bash
terraform destroy -target aws_security_group_rule.sg_rule_sg_r1_az3_allow_all_internal ./terraform/
```

### Simulate DC outage

Remove security group rules for the whole Region 2.

```bash
terraform destroy \
    -target aws_security_group_rule.sg_rule_elb_r2_allow_http \
    -target aws_security_group_rule.sg_rule_default_r2_allow_all_internal \
    ./terraform/
```

### Notice

The source code contained in this project is designed for demonstration purposes and it's not intended to be used 
for production use. The software is provided "as is", without warranty of any kind.  Any use by you of the source 
code is at your own risk.

[ddac]: https://www.datastax.com/products/datastax-distribution-of-apache-cassandra
[aws-vault]: https://github.com/99designs/aws-vault
[aws-okta]: https://github.com/segmentio/aws-okta
[okta]: https://www.okta.com/
[packer]: https://www.packer.io/
[terraform]: https://www.terraform.io/
[elb]: https://aws.amazon.com/elasticloadbalancing/
[gacc]: https://aws.amazon.com/global-accelerator/