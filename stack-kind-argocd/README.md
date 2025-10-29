# Kind Kubernetes Cluster with ArgoCD

A complete infrastructure stack that deploys a single-node [Kind](https://kind.sigs.k8s.io/) Kubernetes cluster on AWS EC2 with [ArgoCD](https://argoproj.github.io/cd/) for GitOps continuous deployment.

## 🚀 Overview

This stack provides a fully automated deployment of a development-ready Kubernetes environment with:

- **Kind Kubernetes Cluster**: Single-node cluster for development and testing
- **ArgoCD**: GitOps continuous deployment tool
- **NGINX Ingress Controller**: For external access to applications
- **GitHub Repository**: Automatically created for ArgoCD applications
- **AWS Infrastructure**: EC2 instance with proper networking and security

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    AWS Infrastructure                   │
├─────────────────────────────────────────────────────────┤
│  EC2 Instance (t3.micro)                                │
│  ┌───────────────────────────────────────────────────┐  │
│  │              Kind Kubernetes Cluster              │  │
│  │  ┌─────────────────────────────────────────────┐  │  │
│  │  │              ArgoCD Server                  │  │  │
│  │  │  • GitOps Continuous Deployment             │  │  │
│  │  │  • Web UI on port 443                       │  │  │
│  │  │  • Admin credentials stored in Cycloid      │  │  │
│  │  └─────────────────────────────────────────────┘  │  │
│  │  ┌─────────────────────────────────────────────┐  │  │
│  │  │         NGINX Ingress Controller            │  │  │
│  │  │  • External access to applications          │  │  │
│  │  │  • SSL termination                          │  │  │
│  │  └─────────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

## ✨ Features

### 🐳 **Kind Kubernetes Cluster**
- Single-node cluster for development and testing
- Pre-configured with proper networking
- Includes kubectl, helm, and docker

### 🔄 **ArgoCD GitOps**
- Latest ArgoCD version deployment
- Web UI accessible via HTTPS
- Admin credentials securely stored in Cycloid
- Ready for GitOps workflows

### 🌐 **NGINX Ingress Controller**
- Pre-installed and configured
- External access to applications
- SSL termination support
- Port 80 and 443 exposed

### 🔐 **Security & Access**
- AWS Systems Manager (SSM) integration
- SSH key management
- GitHub repository with deploy keys
- Secure credential storage in Cycloid

### 📧 **Notifications**
- Email notifications via Mailjet
- Infrastructure status updates
- Automated cleanup notifications

## 🛠️ Prerequisites

Before deploying this stack, ensure you have:

1. **AWS Account** with appropriate permissions
2. **GitHub Account** with Personal Access Token
3. **Cycloid Platform** access
4. **Mailjet Account** (for notifications)

### Required Credentials

- `aws_cred`: AWS access key and secret key
- `github_pat`: GitHub Personal Access Token with `repo` scope
- `mailjet.api_key` & `mailjet.secret_key`: Mailjet API credentials
- `cy_api_key`: Cycloid API key

## 📋 Configuration

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `aws_cred` | AWS credentials | `((aws))` |
| `aws_region` | AWS region | `eu-west-1` |
| `github_pat` | GitHub PAT | `((github-pat.token))` |
| `mailjet.api_key` | Mailjet API key | `((mailjet.api_key))` |
| `mailjet.secret_key` | Mailjet secret key | `((mailjet.secret_key))` |

### Optional Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `vm_instance_type` | EC2 instance type | `t3.micro` |
| `vm_disk_size` | Disk size in GB | `20` |
| `argocd_version` | ArgoCD version | Latest |
| `destroy_timer_in_minutes` | Auto-destroy timer | `10` |

## 🚀 Deployment

### 1. **Stack Setup**
```bash
# Clone or download the stack
# Configure in Cycloid platform
```

### 2. **Configure Variables**
- Set required credentials in Cycloid vault
- Configure AWS region and instance settings
- Set up Mailjet for notifications

### 3. **Deploy Infrastructure**
- Run the pipeline in Cycloid
- Wait for EC2 instance provisioning
- Kind cluster will be automatically created
- ArgoCD will be deployed and configured

### 4. **Access ArgoCD**
- ArgoCD UI: `https://argocd.example.com`
- Username: `admin`
- Password: Retrieved from Cycloid credentials

## 📊 Outputs

After successful deployment, you'll have:

- **EC2 Instance**: Running Kind Kubernetes cluster
- **ArgoCD Server**: Accessible via web UI
- **GitHub Repository**: For your applications
- **Credentials**: Stored securely in Cycloid
- **Kubeconfig**: Available for local access

## 🔧 Day 2 Operations

### **Access the Cluster**
```bash
# Get kubeconfig from Cycloid
# Use kubectl to manage the cluster
kubectl get nodes
kubectl get pods -n argocd
```

### **Deploy Applications**
```bash
# Create ArgoCD applications
argocd app create my-app \
  --repo https://github.com/your-repo/app \
  --path k8s \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default
```

### **Monitor Applications**
- Access ArgoCD UI for application monitoring
- Check application sync status
- View deployment logs

## 🧹 Cleanup

The stack includes automatic cleanup functionality:

- **Auto-destroy timer**: Configurable cleanup delay
- **Manual cleanup**: Destroy via Cycloid pipeline
- **Resource cleanup**: All AWS resources removed

## 🔍 Troubleshooting

### **Common Issues**

1. **Kind cluster not starting**
   - Check Docker service status
   - Verify system resources
   - Review userdata logs

2. **ArgoCD not accessible**
   - Verify ingress controller status
   - Check SSL certificate
   - Review ArgoCD pod logs

3. **GitHub repository issues**
   - Verify GitHub PAT permissions
   - Check deploy key configuration
   - Review repository access

### **Logs and Debugging**
```bash
# Check Kind cluster status
kind get clusters

# Check ArgoCD pods
kubectl get pods -n argocd

# Check ingress controller
kubectl get pods -n ingress-nginx

# View ArgoCD logs
kubectl logs -n argocd deployment/argocd-server
```

## 📚 Resources

- [Kind Documentation](https://kind.sigs.k8s.io/)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
- [Cycloid Documentation](https://docs.cycloid.io/)

## 🤝 Contributing

This stack is part of the Cycloid onboarding stacks collection. For contributions:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Built with ❤️ by the Cycloid Team**