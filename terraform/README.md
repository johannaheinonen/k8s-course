# Kubernetes Installation (unmanaged)
After these steps you have:  
- a workstation (EC2 or your own machine) that contains required tools
- Two EC2 instances in AWS Learner Lab ready for Kubernetes Installation


## Setup the Workstation
The following instructions assume that the workstation is an EC2 instance in AWS. If you want to use your own laptop as the workstation, the instructions can be found here: 

- Create EC2
- AWS Learner Lab credentials (AWS Details tab) 
   - Notice: these need to be set every time the Learner Lab environment is started.  
```
export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXX"
export AWS_SESSION_TOKEN="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```
- Install the following tools:
    - Terraform



## Terraform

How to run terraform?
in linux machine:

Check from AWS Details:

export AWS_ACCESS_KEY_ID="ASIA275LE6DV"
export AWS_SECRET_ACCESS_KEY="TK7Nww0R4vfYTOWvOercRE80zVIql"
export AWS_SESSION_TOKEN="IQoJb3J/O4WoccoR65tWK2C8VIIJZtw3NbK/VFIdoLvokftbl7DSUiOmSaoRCsy6aJknAc/4mzmqfZ/ZB9ehXBx7G2bIaC91E+ry9mu+DL4oiXUKEyeNA3pKpNid12WqvUfA=="
install terraform

   sudo apt-get update
   sudo apt install -y gnupg software-properties-common curl
   sudo apt install -y gnupg curl
   curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt-get update
   
terraform init
terraform plan => 3 resources to be created: security group and two k8s-nodes.
terraform apply
Some TSH
aws ec2 describe-images \
>   --owners 136693071363 \
>   --filters "Name=name,Values=debian-13-amd64-*" \
>   --query 'sort_by(Images,&CreationDate)[-5:].[ImageId,Name]' \
>   --output table
------------------------------------------------------------
|                      DescribeImages                      |
+------------------------+---------------------------------+
|  ami-0e411f364f7b13544 |  debian-13-amd64-20261001-2618  |
|  ami-0ac4bfa753dc256cc |  debian-13-amd64-20261015-2632  |
|  ami-0487c680eaaec4b80 |  debian-13-amd64-20261017-2634  |
|  ami-0bd74f3706bb4acb8 |  debian-13-amd64-20261021-2638  |
|  ami-0b43a454bbb93640a |  debian-13-amd64-20261026-2643  |
+------------------------+---------------------------------+

aws ec2 run-instances \
>   --image-id ami-0b43a454bbb93640a \
>   --instance-type t2.large \
>   --key-name vockey \
>   --subnet-id subnet-0bf3cc5c967ca3e40


aws: [ERROR]: An error occurred (InsufficientInstanceCapacity) when calling the RunInstances operation (reached max retries: 2): We currently do not have sufficient t2.large capacity in the Availability Zone you requested (us-east-1e). Our system will be working on provisioning additional capacity. You can currently get t2.large capacity by not specifying an Availability Zone in your request or choosing us-east-1a, us-east-1b, us-east-1c, us-east-1d, us-east-1f.
~ $ 
when getting error
error: creating EC2 Instance: operation error EC2: RunInstances, https response error StatusCode: 400, RequestID: 66289004-f45c-4db1-8b59-7ad2555f64f5, api error Unsupported: Your requested instance type (t3.large) is not supported in your requested Availability Zone (us-east-1e). Please retry your request by not specifying an Availability Zone or choosing us-east-1a, us-east-1b, us-east-1c, us-east-1d, us-east-1f.

check this:

 aws ec2 describe-subnets \
>   --query 'Subnets[*].[SubnetId,AvailabilityZone]' \
>   --output table
--------------------------------------------
|              DescribeSubnets             |
+---------------------------+--------------+
|  subnet-0bf3cc5c967ca3e40 |  us-east-1e  |
|  subnet-0eaadd530028520ea |  us-east-1a  |
|  subnet-0ba82cac970484157 |  us-east-1b  |
|  subnet-0428415983771ba08 |  us-east-1d  |
|  subnet-076a86e03f2468cc1 |  us-east-1f  |
|  subnet-0359cbed020dbd9c9 |  us-east-1c  |
+---------------------------+--------------+


if using user data to run the scripts: user_data = file("${path.module}/controller.sh")
