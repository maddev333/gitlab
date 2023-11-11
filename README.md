# Inital install (Docker)
```
Install Rocky
resize - cfdisk /dev/sda, growpart /dev/sda 3, xfs_growfs /
Install Docker
sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
#wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode 0644 --disable traefik --tls-san "$MASTER_IP" --node-external-ip "$MASTER_IP" --token 12345" sh -s -

sudo dnf update -y

```
# K3S
```
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC=“-write-kubeconfig-mode 644 —no-deploy traefik —disable traefik —tls-san “$MASTER_IP” —node-external-ip “$MASTER_IP” —disable servicelb “ sh -s -

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode 644 --token some_random_password --bind-address 10.231.19.216 --disable local-storage" sh -s -
journalctl -xeu k3s.service
systemctl status k3s.service

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode 644 —no-deploy traefik —disable traefik —tls-san $MASTER_IP —node-external-ip $MASTER_IP --disable local-storage" sh -s -

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server" sh -s - --token 12345 --disable traefik --write-kubeconfig-mode 644 --tls-san $MASTER_IP --node-external-ip $MASTER_IP --disable local-storage

curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.26.10-rc3+k3s2 INSTALL_K3S_EXEC="server" sh -s - --token 12345 --disable traefik --write-kubeconfig-mode 644 --tls-san $MASTER_IP --node-external-ip $MASTER_IP


curl -Lo /usr/local/bin/k3s https://github.com/k3s-io/k3s/releases/download/v1.26.10-rc3+k3s2/k3s; chmod a+x /usr/local/bin/k3s


sudo /usr/local/bin/k3s server --write-kubeconfig-mode=644 --token 12345 --disable traefik --write-kubeconfig-mode 644 --tls-san $MASTER_IP --node-external-ip $MASTER_IP


kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.5.1/deploy/longhorn.yaml

# First add metallb repository to your helm
helm repo add metallb https://metallb.github.io/metallb
# Check if it was found
helm search repo metallb
# Install metallb
helm upgrade --install metallb metallb/metallb --create-namespace \
--namespace metallb-system --wait

cat << 'EOF' | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: default-pool
  namespace: metallb-system
spec:
  addresses:
  - 10.231.19.216-10.231.19.216
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: default
  namespace: metallb-system
spec:
  ipAddressPools:
  - default-pool
EOF
kubectl get svc -A

https://raw.githubusercontent.com/longhorn/longhorn/v1.4.0/scripts/environment_check.sh

helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --set defaultSettings.defaultDataPath="/storage01" --version 1.5.2

helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace" --version 1.5.2

kubectl delete -f https://raw.githubusercontent.com/longhorn/longhorn/v1.5.2/deploy/longhorn.yaml


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

curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION="v1.26.9+rke2r1" INSTALL_RKE2_TYPE="agent" sh -
systemctl enable rke2-agent.service
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
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/baremetal/deploy.yaml


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

helm upgrade --install agent gitlab/gitlab-agent --namespace gitlab-agent-agent --create-namespace --set image.tag=v16.4.0 --set config.token=glagent-i6tVQKBFKuBtaNWbgR3akyAZVjFFmZGKs5JYTVvkyqxxmFDzJQ --set config.kasAddress=wss://kas.example.com --set-file config.caCert=gitlab.example.com.crt

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

# Multipass
```
multipass launch --name k3s-demo --cpus 2 --mem 4g --disk 20g
multipass exec k3s-demo -- bash -c "curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server" sh -s - --token 12345 --disable traefik --write-kubeconfig-mode 644"

multipass launch --name k3s-agent --cpus 2 --mem 8g --disk 40g
multipass exec k3s-agent -- bash -c 'curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent" sh -s - --token 12345 --server https://172.20.132.15:6443'

multipass shell k3s-demo
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/baremetal/deploy.yaml

multipass launch --name gitlab --cpus 2 --mem 4g --disk 40g
multipass exec gitlab -- bash -c 'curl -s https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash'
multipass exec gitlab -- bash -c 'sudo apt install gitlab-ce'
sudo cat /etc/gitlab/initial_root_password

helm repo add gitlab https://charts.gitlab.io
helm repo update
helm upgrade --install agent1 gitlab/gitlab-agent \
    --namespace gitlab-agent-agent1 \
    --create-namespace \
    --set image.tag=v16.5.0 \
    --set config.token=glagent-m5tQBjx7h4ZzYPpqV9x-w2zaREAXFhyb9KBssAQgxRVY8LFx_g \
    --set config.kasAddress=ws://gitlab.example.com/-/kubernetes-agent/

```