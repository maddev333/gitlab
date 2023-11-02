# Inital install (Docker)
```
Install Rocky
Install Docker
sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

```
# Cluster create RKE2
```
curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION="v1.26.9+rke2r1" sh -
systemctl enable rke2-server.service
systemctl start rke2-server.service
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
alias k=/var/lib/rancher/rke2/bin/kubectl
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
#curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"


```
# Install Rancher
```
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo add jetstack https://charts.jetstack.io
k apply -f https://github.com/jetstack/cert-manager/releases/download/v1.6.1/cert-manager.crds.yaml
helm upgrade -i cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace
helm upgrade -i rancher rancher-latest/rancher --create-namespace --namespace cattle-system --set hostname=rancher.example.com --set bootstrapPassword=bootStrapAllTheThings --set replicas=1

```
# Install Nginx ingress controller
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx --create-namespace --set controller.publishService.enabled=true
```
# Install Harbor
```
helm repo add harbor https://helm.goharbor.io
helm fetch harbor/harbor --untar
Update values.yml
 ingress:
    hosts:
      core: core.kubemaster.me
      className: "traefik"

helm install harbor harbor/
```

# Install Nexus
```
helm repo add sonatype https://sonatype.github.io/helm3-charts/
helm fetch sonatype/nexus-iq-server --untar
ingress:
  enabled: true
  ingressClassName: traefik
  #annotations:
  #  nginx.ingress.kubernetes.io/proxy-body-size: "0"

helm install nexus nexus-iq-server/
```
# Github Helm
```
Install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
Run gitlab_create_helm.sh

```
# Github runner running on Docker
```
sudo docker pull gitlab/gitlab-runner:latest
sudo docker volume create gitlab-runner-config
sudo docker run -d --name gitlab-runner --restart always -v /var/run/docker.sock:/var/run/docker.sock -v gitlab-runner-config:/etc/gitlab-runner gitlab/gitlab-runner:latest
```

# Github runner register with Docker executor
```
(self-signed cert) openssl s_client -showcerts -connect gitlab.example.com:443 -servername gitlab.example.com < /dev/null 2>/dev/null | openssl x509 -outform PEM > gitlab.example.com.crt
sudo docker cp gitlab.example.com.crt gitlab-runner:/etc/gitlab-runner/certs/ca.crt

docker run --rm -it -v /srv/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner register --tls-ca-file=gitlab.example.com.crt

```
Enter an executor: custom, docker-windows, ssh, virtualbox, docker+machine, instance, docker, parallels, shell, docker-autoscaler, kubernetes: docker
Enter the default Docker image (for example, ruby:2.7): microsoft/dotnet-framework:4.7.2
```

(Restart after install) sudo docker restart gitlab-runner 
```
# Windows build container
```
Docker desktop running on windows pro needed
docker pull mcr.microsoft.com/windows/nanoserver:ltsc2022
docker run -it mcr.microsoft.com/windows/nanoserver:ltsc2022 cmd.exe
```