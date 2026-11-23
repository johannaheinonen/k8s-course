## Setup the Workstation
The following instructions assume that the workstation is an EC2 instance in AWS. If you want to use your own laptop as the workstation, the instructions can be found here: https://github.com/johannaheinonen/johanna-test-repo/blob/main/module_6.md  

- Create EC2
- AWS Learner Lab credentials (AWS Details tab) 
   - Notice: these need to be set every time the Learner Lab environment is started.  
```
export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXX"
export AWS_SESSION_TOKEN="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```
- Install the following tools:
    - Terraform
