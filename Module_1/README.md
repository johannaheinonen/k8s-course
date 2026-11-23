# Kubernetes Installation (unmanaged)

The target: Kubernetes installation to two EC2 instances by using __kubeadm__ tool which is the official Kubernetes command-line tool for bootstrapping minimum viable clusters.  

Steps:  
1. Create workstation.  
2. Use terraform to create two EC2 instances. One will be the k8s controller and another k8s worker node.  
3. Run k8s-controller.sh and k8s-worker.sh scripts that install k8s to these EC2 instances.  
4. Copy the ~/.kube/config file from controller node to the workstation. 

