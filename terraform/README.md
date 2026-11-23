# Kubernetes Installation (unmanaged)
After these steps you have:  
- a workstation (EC2 or your own machine) that contains required tools
- Two EC2 instances in AWS Learner Lab ready for Kubernetes Installation


## Setup the Workstation
The following instructions assume that the workstation is an EC2 instance in AWS. If you want to use your own laptop as the workstation, the instructions can be found here: https://github.com/johannaheinonen/johanna-test-repo/blob/main/module_6.md  

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



## Terraform Installation

```
   sudo apt-get update
   sudo apt install -y gnupg software-properties-common curl
   sudo apt install -y gnupg curl
   curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt-get update
   
terraform init
terraform plan => 3 resources to be created: security group and two k8s-nodes.
terraform apply
```

if using user data to run the scripts: user_data = file("${path.module}/controller.sh")
