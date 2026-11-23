# Kubernetes Installation (unmanaged)

__The target__: Kubernetes installation to two EC2 instances by using __kubeadm__ tool which is the official Kubernetes command-line tool for bootstrapping minimum viable clusters.  

__Pre-requisite__: workstation where terraform, kubectl and other necessary tools are installed.  

__Steps__:  
1. Use terraform (main.tf) to create two EC2 instances (one controller node and one worker node) and a security group.
   
2. ```ssh``` to the controller node EC2 and do the following:  
- open nano editor: ```nano k8s-controller.sh```
- copy the contents of ```k8s-controller.sh``` script here and change the ```NODE_IP="<Controller Node private IP-address>"```  
- give executive permissions to the script: ```chmod +x k8s-controller.sh```  
- run the script: ```./k8s-controller.sh```
- wait until the controller node is ready. To check this run the following command on controller node:
```
kubectl  get nodes

NAME             STATUS   ROLES           AGE   VERSION
ip-172-31-14-7   Ready    control-plane   41m   v1.37.0
```
In Kubernetes cluster all worker nodes need to be joined to the controller. This is done with join-command:  ```kubeadm token create --print-join-command```  which gives the output:
```
kubeadm join <Controller node IP-address>:6443 \  
  --token abcdef.1234567890123456 \  
```
copy this command, it is later run in the worker node.  

3. ```ssh``` to the worker node EC2 and do the following:  
- open nano editor: ```nano k8s-worker.sh```  
- copy the contents of ```k8s-worker.sh``` script and change the ```NODE_IP="<Worker Node private IP-address>"``` and ```CONTROL_PLANE_IP="<Controller Node private IP-address>"```  
- give executive permissions to the script: ```chmod +x k8s-worker.sh```
- run the script: ```./k8s-worker.sh```
- run the above generated ```kubeadm join``` command. The output of ```kubectl  get nodes``` should show two nodes in state ```ready```.  

4. The Kubernetes cluster is now installed. In controller node check that the nodes and pods are all ```running```:
```
kubectl get nodes
kubectl get pods -A
```
5. In order to use ```kubectl``` from the workstation, copy the ```~/.kube/config``` file from the controller node to the workstation. (Instructions in the workstation folder)  

