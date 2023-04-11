##Tools installation on a linux machine
Install eksctl
```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```
Install kubectl
```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```
Install aws-cli
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

##Enviroment setting for AWS
```
aws configure --profile username
input access key
input secret key
input region
input format
vim ~/.aws/credentials  # check your credentials
on provider.tf change the profile_name for yours
```


## To deploy the infrastructure
First clone the repository and move into de repository
```
git clone https://github.com/Jiolloker/webdemo.git
```
You can also clone a specific branch
```
git clone -b terraform_test https://github.com/Jiolloker/webdemo.git
```
Move into folder, download resources with init and plan to check if everything is okey
```
cd webdemo
cd into the workspace folder of your choice
terraform init
terraform plan
```
add --auto-approve to ignore the confirmation prompt or simply leave it out and when prompted for confirmation answer yes
```
get into the different workspaces with ..
terraform workspace new dev  #change into dev, prod or staging and then
terraform apply --auto-approve
```
With this you may have deployed the infrastructure. You can check the status of the infrastructure with...
```
terraform show
rm ~/.kube/config
aws eks update-kubeconfig --name prod-eks-webdemo --alias prod-eks-webdemo --region us-east-1 --profile profilename
kubectl get nodes
```
After that, we can deploy a testing nginx server to check if we can get something from the cluster
```
kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml -n nginx
kubectl apply -f service.yaml -n nginx
```
Check if everything is running
```
kubectl get pods -n nginx
kubectl get svc -n nginx
```
Copy the External_ip displayed in the service to try a curl, you should see nginx welcome page.
```
curl http://<nginx-service-ip>

```
##Destroy the infrastructure
```
kubectl delete namespace nginx
terraform destroy --auto-approve
```
## Link a la presentacion en proceso.
https://docs.google.com/presentation/d/1eE2JTty0yak0BQDvE48MWC0hFd_LResiptOVYJAdJck/edit#slide=id.g21a97ba0fc6_0_130






---  ---  ---  --- 
## Local deployment for testing purposes.

