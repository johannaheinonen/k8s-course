## Workstation

A workstation is needed in order to install and operate Kubernetes, use AWS cli and run terraform. These instructions assume that the workstation is EC2 running Debian 13.x but it can be also any other Linux machine. More generic instructions how to set up the workstation can be found here: https://github.com/johannaheinonen/johanna-test-repo/blob/main/module_6.md  

### EC2 for Workstation


- Create EC2  - params? t2.micro, vockey, debian13, labrole -
  download labsuser.pem and ssh to workstation ec2.
  
- AWS Learner Lab credentials (AWS Details tab)   
   - Notice: these need to be set every time the Learner Lab environment is started.  
   - This makes it possible to use aws cli. Test ```aws sts get-caller-identity```  
```
export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXX"
export AWS_SESSION_TOKEN="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```
- Install the following tools:
    - Terraform  - install script
    - kubectl - install script
  
    - after Kubernetes is installed
      ```
      mkdir ~/.kube
      copy/paste ssh key to file labsuser.pem
      scp -i labsuser.pem admin@172.31.4.141:~/.kube/config ~/.kube/config   ## controller private IP

      test kubectl: kubectl get nodes
      ```
      
