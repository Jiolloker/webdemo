# Tools installation on a linux machine
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


# To deploy the infrastructure
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
# Destroy the infrastructure
```
kubectl delete namespace nginx
terraform destroy --auto-approve
```
# Link a la presentacion en proceso.
https://docs.google.com/presentation/d/1eE2JTty0yak0BQDvE48MWC0hFd_LResiptOVYJAdJck/edit#slide=id.g21a97ba0fc6_0_130




<br>

---  ---  ---  --- 
## Local deployment for testing purposes.

<br>

### Herramientas a instalar en maquina linux
---

<br>

- Minikube
- jenkins
- argoCD
- docker
- eksctl
- kubectl
- aws-cli
- curl
- git
- docker-compose

<br>
<br>

### Levantar Jenkins con docker-compose.
---

<br>

```bash
cd webdemo/terraform/yaml
```
```bash
docker-compose up -d
```

<br>

### Plugins y herramientas a instalar en jenkins
---

<br>

- configurar credenciales github_id dockerhub_id
- Instalar plugins nodejs , docker , gitpush , snyk
- En la configuracion de nodeJS en el name ponerle nodejs_for_test
- En la configuracion de docker (configure clouds) poner:  tcp://docker:2376
- Se debe generar una credencial del tipo secret text con el nombre **snyktoken** y el token correspondiente de la cuenta de snyk (esto esta declarado en el stage snyk scan )
- Se debe generar una credencial del tipo secret text con el nombre **token-github** y el token correspondiente de github (esto se declarar en el stage issues)
- Dentro del contenedor de jenkins instalar snyk: 

```bash
wget https://github.com/snyk/snyk/releases/download/v1.667.0/snyk-linux
chmod +x snyk-linux
sudo mv snyk-linux /usr/local/bin/snyk
```

<br>


### Levantar Minikube
---
<br>

```
minikube start
```

<br>

### Instalar ArgoCD en k8s
---
<br>

```
minikube kubectl -- create namespace argocd
```
```bash
minikube kubectl -- apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
<br>

### Acceder ArgoCD UI
---
<br>

```bash
minikube -- kubectl get svc -n argocd
```
```bash
minikube -- kubectl port-forward svc/argocd-server 8080:443 -n argocd
```
<br>

### Obtener credenciales de ArgoCD:
---

<br>

```
minikube kubectl -- -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo
```
<br>


### Diagrama de proceso CI/CD
---

<br>

![DiagramaCICD](/img/cicd.png)

