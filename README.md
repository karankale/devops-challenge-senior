# SimpleTimeService

A lightweight, production-grade Python microservice that returns the current UTC timestamp and the client IP address as JSON.

---

## JSON API Output

```json
{
  "timestamp": "2025-04-14T12:00:00Z",
  "ip": "203.0.113.42"
}
```

---

## Project Overview

| Component      | Stack Used                             |
|----------------|----------------------------------------|
| App            | Python (Flask), Gunicorn               |
| Container      | Docker (non-root, slim image)          |
| CI/CD          | GitHub Actions (Build → Scan → Push)   |
| Infra          | Terraform: VPC + EKS + K8s-app         |
| Deployment     | Kubernetes Deployment + Service        |

---

## 1. Docker Build & Push (Manual)

If you want to build and push the Docker image manually:

```bash
docker build -t karankale/simple-time-service:v1 .
docker login
docker push karankale/simple-time-service:v1
```

---

## 2. GitHub Actions CI/CD

A workflow in `.github/workflows/deploy.yml` automatically:

1. Builds and tags image based on branch/tag name
2. Scans it using Trivy
3. Pushes it to Docker Hub
4. Runs Terraform to deploy infra and the app

### Required GitHub Secrets

| Name                   | Description |
|------------------------|-------------|
| `AWS_ACCESS_KEY_ID`    | AWS Access Key |
| `AWS_SECRET_ACCESS_KEY`| AWS Secret Key |

---

## 3. AWS CLI Setup

```bash
aws configure
```

- Enter AWS access key
- AWS secret key
- Region (e.g. `us-east-1`)
- Output format (e.g. `json`)

---

## 4. Terraform Infrastructure (Manual Deploy)

```bash
cd simple-time-service-infra
terraform init
terraform plan -var="container_image=karankale/simple-time-service:v1"
terraform apply -var="container_image=karankale/simple-time-service:v1" -auto-approve
```

This will:

- Create VPC with public/private subnets
- Deploy EKS cluster + managed node group
- Deploy the container app
- Expose the app using LoadBalancer service

---

## 5. Access the Application

Once deployed, run:

```bash
kubectl get svc simple-time-app -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```
This will give you the load balancer address
Then visit:

```
http://<your-lb-dns-name>/
```

---

## 6. Troubleshooting

- If `kubectl get nodes` fails with timeout:
  - You may be on a public machine accessing a private EKS endpoint
  - Use a VPN, bastion host, or enable public access temporarily

- If nodes are not ready:
  - Terraform includes a `null_resource` to wait for node readiness

---
