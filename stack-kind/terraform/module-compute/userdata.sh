#!/bin/bash
# To install SSM Agent on Debian Server
# https://docs.aws.amazon.com/systems-manager/latest/userguide/agent-install-deb.html
mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
dpkg -i amazon-ssm-agent.deb
systemctl status amazon-ssm-agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
# Install Docker
until sudo apt-get update; do sleep 1; done
sudo apt-get install git ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
until sudo apt-get update; do sleep 1; done
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo systemctl start docker
sudo systemctl enable docker
docker --version
# Install Kubectl
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client
# Install Kind
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-amd64
[ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-arm64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
mkdir -p /home/${USERNAME}/.kube
kind create cluster
# Install Helm
cd /tmp
curl -sL https://get.helm.sh/helm-v3.17.1-linux-amd64.tar.gz | tar -xvz
sudo mv linux-amd64/helm /usr/bin/helm
sudo chmod +x /usr/bin/helm
rm -rf linux-amd64
export KUBECONFIG=/home/${USERNAME}/.kube/config
helm upgrade --set controller.hostPort.enabled=true --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace
