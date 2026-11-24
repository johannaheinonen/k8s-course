## Workstation

A workstation is required to install and manage Kubernetes, use the AWS CLI, and run Terraform. Before starting, the workstation must be properly configured with the necessary tools and access credentials.  

These instructions use an Amazon EC2 instance running Debian 13.x as the workstation. However, any Linux workstation can be used, including a physical PC, laptop, virtual machine, or cloud-based Linux instance. General workstation setup instructions are available here: https://github.com/johannaheinonen/johanna-test-repo/blob/main/module_6.md  


### EC2 

The EC2 instance for the workstation is launched via AWS management console with the following parameters:  
- name: workstation
- Amazon Machine image (AMI): debian
- instance type: t2.micro
- new security group, ssh access enabled
- key pair: vockey
- Advanced details -> IAM Instance profile -> LabInstanceProfile
Other parameters can be left at their default values.  

Next connect to the EC2 instance using SSH. For this download the SSH key from AWS Academy learner lab. 
- download labsuser.pem and ssh to workstation ec2.
  
- AWS Learner Lab credentials (AWS Details tab) - export 
   - Notice: these need to be set every time the Learner Lab environment is started.  
   - This makes it possible to use aws cli. Test ```aws sts get-caller-identity```  
```
export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXX"
export AWS_SESSION_TOKEN="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```
to test that aws cli works:
```
aws sts get-caller-identity
{
    "UserId": "AROA275LE6DVAATO4FOFG:user5618902=_Student_View__Johanna_Heinonen",
    "Account": "755736309994",
    "Arn": "arn:aws:sts::755736309994:assumed-role/voclabs/user5618902=_Student_View__Johanna_Heinonen"
}
```
- Install the following tools:
    - Terraform  - install script
    - kubectl - install script
    - (AWS CLI is pre-installed in EC2)
  
    - after Kubernetes is installed
      ```
      mkdir ~/.kube
      copy/paste ssh key to file labsuser.pem
      copy/paste ssh key: labsuser.pem 
      in linux: chmod 400 labsuser.pem

      scp -i labsuser.pem admin@172.31.4.141:~/.kube/config ~/.kube/config   ## controller private IP

      test kubectl: kubectl get nodes
      ```
      
