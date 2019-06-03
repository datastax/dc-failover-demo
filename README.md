# Provisioning and deployment files for Multi DC failover demo

Terraform configurations for provisioning:

- 10 EC2 instances for DSE nodes segregated in two data-centers:
    - Region us-east-1: 5 `m5a.2xlarge` instances across 3 Availability Zones (AZ). 
    - Region us-west-1: 5 `m5a.2xlarge` instances across 3 AZs.
- 6 EC2 instances (size?) to be used for application services, one in each region.
- 2 EC2 instances (size?) to be used as clients, one in each region. 
- 6 ELB, one per each AZ, with health checks enabled.
- Route53 DNS with health checks enabled, with A records that are mapped to ELB the instances.
