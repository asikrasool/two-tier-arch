# Provisioning Two Tier Architecture in AWS Using Terraform.
This repository contains terraform configuration files to provision multiple EC2 instance backed by ALB, and RDS in private subnet accessible by EC2 instances.
You can click [here](https://github.com/asikrasool/two-tier-arch?tab=readme-ov-file#instruction) to start provision the resources.
# Terraform Modules and Resources:
## VPC 
  * TF module to create a VPC with multiple number of public, private subnets, Internet and NAT gateways
  Just pass the multiple CIDRs, how many subnets you want to create in  "private_subnets" , "public_subnets" variable.
  * Variables:
    1) `project`         - Name of project that vpc will be used for.
    2) `env`             - Environment name
    3) `vpc_cidr_block`  - Specify CIDR block used for entire vpc network
    4) `azs`             - List of Availability Zones for subnets.
    5) `public_subnets`  - List of CIDR ranges for public subnets, specify multiple cidr in a list to create multiple public subnets
    6) `private_subnets` - List of CIDR ranges for private subnets, specify multiple cidr in a list to create multiple private subnets
    7) `private_subnet_tags` && `public_subnet_tags` - Tags used to identify and differentiate subnet resources.

## Compute
* This module is designed to create number of Ec2 instance based on total number of Public/Private Subnets. It also create EIP for all the EC2 instance that is being created along with SSH key pair from public key that we are providing.

* Variables
    1) `ami`           - AMI for the EC2 instance.
    2) `instance_type` - The instance type for the EC2 instance.
    3) `subnet_id`     - List of subnet IDs where the EC2 instance will be launched.
    4) `sg`            - Security group that allows public access via HTTP/SSH.
    5) `user_data`     - User data that will install tools on startup
    6) `public_access` - Associate Public IP to the instance.
    7) `pub_key`       - SSH Public Key to access the EC2 Server.
    8) `ssh_key_name`  - SSH key name to be created with the specified public key.
    9) `project`       - Name of project that vpc will be used for.
    10) `env`          - Environment name

## RDS(MySQl)
* This module is written to create any type of RDS instance along with random DB password which will later stored in AWS Secret manager.

* Variables
    1) `publicly_accessible`   - Determines if the RDS instance can be publicly accessed.
    2) `multi_az`      - Specifies if the RDS instance is a Multi-AZ deployment.
    3) `subnet_ids`      - List of subnet IDs where the RDS instance will be placed.
    4) `rds_security_group_id` - Security group that allows only access from webserver's.
    5) `db_name`       - The name of database that is created when instance is up.
    6) `username`      - The db username used login into the database.
    7) `port`          - The port on which the RDS instance accepts connections..
    8) `identifier`    - The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier.
    9) `project`     - Name of project that vpc will be used for.
    10) `env`        - Environment name
    11) `Instance class` - The instance type of the RDS instance.
    12) `engine` - The name of the database engine to be used for the DB instance.(Ex: "mysql")
    13) `engine_version` - Provide any major version fo specified engine
    14) `storage_type` - The default is "io1" if iops is specified, "gp2" if not
    15) `allow_major_version_upgrade` - When upgrading the major version of an engine, allow_major_version_upgrade must be set to true
    16) `snapshot_identifier` - used to recover db from snapshot, snapshot id should be provided

* This module is fully paramaterized to configure multiple RDS engines, also it can used to recover instance from snapshots.

There are few resources which are not modularized. ALB and Security groups.

* `alb.tf` - Create Target Group with stickness and round robin algorithm, also it create load balance with listner rule which forward all incoming traffic to target group backed by two ec2 instance that we create using `compute` module. Yes, it also attached those instance to this target group.

* `sg.tf` - Create security groups for ec2, rds, alb with specified ingress and egress rules, where one of the rule we create only allow traffic to rds instance from ec2(web_app) security group alone. There are other security group which allow port 22, 80 etc.

## Instruction
Before running terraform scripts, make sure you have access to aws account. you can configure your aws account using `aws configure` command and provide `access_key` and `secret_key`.

* `terraform init`: Initialize terraform which will download provider,modules and backend, we use AWS S3 as remote backend to store our statefile remotely.
* `terraform fmt` : this command used to refactor the code to terraform convention and make is easy to read for everyone
* `terraform validate`: this command used to validate terraform syntax, dependencies and deprecated warnings and version mismatch etc
* `terraform plan`: Always run terrafrom plan to review what resources are going to get created, make sure terraform plan output is align with our expectation.
* `terraform apply`: it combination of plan and apply command, it will once again provide plan output with approve prompt, if everything looks okay you can approve and terraform will start creating the resources.

* you can use `-target` to create only specific resources. For example, to create only compute and vpc module, run
```
terraform apply -target=module.compute -target=module.vpc
```
* To run only loadbalancer target group and load balancer run
```
terraform apply -target=aws_lb_target_group.my_app_eg1 -target=aws_lb.my_app_eg1
```
* Once all the resources are provisioned, check AWS secret manager to get credentials to connect to rds db instance from ec2 web servers.

* `terraform outputs` - This command will provide alb dns name to access webapp also ec2 public ips.

## Improvement
* We can also improve this setup, by using ASG along with ASG policy and launch template in `alb.tf resources`.
* In rds module, we can improve rds database into master slave architecture along with read replica
* I had mention the environment by folder name with different state file key name, it can be improved by using `terragrunt` with single backend configuration