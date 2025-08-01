#!/bin/bash
# To install SSM Agent on Debian Server
# https://docs.aws.amazon.com/systems-manager/latest/userguide/agent-install-deb.html
set -x
mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
dpkg -i amazon-ssm-agent.deb
systemctl status amazon-ssm-agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
# Enable IP forwarding to reach the validating webhook internally
sudo sysctl -w net.ipv4.ip_forward=1
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
sudo mv ./kubectl /usr/local/bin/kubectl
sudo chmod +x /usr/local/bin/kubectl
kubectl version --client
# Install Helm
curl -sL https://get.helm.sh/helm-v3.17.1-linux-amd64.tar.gz | tar -xvz
sudo mv ./linux-amd64/helm /usr/local/bin/helm
sudo chmod +x /usr/local/bin/helm
helm version
rm -rf linux-amd64
# Install Kind
sudo sysctl net.ipv6.conf.all.disable_ipv6
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-amd64
[ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-arm64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
cat <<-EOF >kind-config.yaml
# three node cluster with an ingress-ready control-plane node
# and extra port mappings over 80/443 and 2 workers
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
- role: worker
EOF
kind create cluster --config kind-config.yaml
sudo mkdir -p /home/${USERNAME}/.kube
sudo kind get kubeconfig > /home/${USERNAME}/.kube/config
sudo chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.kube/config
sudo chmod 644 /home/${USERNAME}/.kube/config && sudo chmod 644 /home/${USERNAME}/.kube/config
export HOME=/home/${USERNAME}
export KUBECONFIG=/home/${USERNAME}/.kube/config
# Install Ingress Nginx Controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/${ARGOCD_VERSION}/manifests/install.yaml
# Install ArgoCD CLI
sudo curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64
sudo chmod +x /usr/local/bin/argocd
# Configure ArgoCD Ingress
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission
sleep 5
cat <<-EOF >argocd-server-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server-ingress
  namespace: argocd
  annotations:
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/ssl-passthrough: "true"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
spec:
  ingressClassName: nginx
  rules:
  - host: argocd.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: argocd-server
            port:
              name: https
EOF
export ARGOCD_EXTERNAL_URL="argocd.$(curl http://169.254.169.254/latest/meta-data/public-ipv4).nip.io"
sed -i "s/argocd.example.com/$ARGOCD_EXTERNAL_URL/" argocd-server-ingress.yaml
kubectl apply -f argocd-server-ingress.yaml
# Configure ArgoCD
export ARGOCD_ADMIN_BCRYPT_PASSWORD="$(argocd account bcrypt --password ${ARGOCD_ADMIN_PASSWORD})"
export ARGOCD_PASSWORD_MTIME="'$(date +%FT%T%Z)'"
kubectl -n argocd patch secret argocd-secret -p "{\"stringData\": {\"admin.password\": \"$ARGOCD_ADMIN_BCRYPT_PASSWORD\", \"admin.passwordMtime\": \"$ARGOCD_PASSWORD_MTIME\"}}"
kubectl -n argocd delete pod -l app.kubernetes.io/name=argocd-server
until argocd login $ARGOCD_EXTERNAL_URL --username admin --password ${ARGOCD_ADMIN_PASSWORD} --grpc-web --insecure; do sleep 5; done
argocd version
echo "${GIT_PRIVATE_KEY}" >/home/${USERNAME}/.ssh/git-argocd
argocd repo add ${GIT_SSH_URL} --ssh-private-key-path /home/${USERNAME}/.ssh/git-argocd