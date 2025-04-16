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
## 4. Terraform Remote Backend Bootstrap with GitHub Actions Flow

This guide explains how to **manually initialize the Terraform remote backend (S3 + DynamoDB)** using Terraform code (one-time setup), and then shift to using **GitHub Actions for all future apply steps**.

---

### Why This Pattern?

- Backend (S3 + DynamoDB) must exist **before** Terraform can store state remotely.
- Terraform cannot manage its own backend on first run.
- GitHub Actions CI/CD relies on that remote backend to work across environments.

---

###  Overview

1. Bootstrap backend using `bootstrap-backend.tf` locally (runs with local state)
2. Enable backend block in `backend.tf`
3. GitHub Actions takes over from then on — using remote state

---

###  Prerequisites

- AWS CLI configured (`aws configure`)
- Terraform >= 1.3
- GitHub Secrets configured:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`

---

###  Step 1: Manually Create Terraform Backend

In your repo:

```
terraform/
├── state
    ├──backend.tf
├── bootstrap-backend.tf
```

###  Run Locally (first time only):

```bash
cd terraform/state
terraform init -backend=false
terraform apply -auto-approve -target=aws_s3_bucket.tf_state -target=aws_dynamodb_table.tf_lock
```

This creates:
- `terraform-state-<unique>` S3 bucket
- `terraform-locks` DynamoDB table

---

### Step 2: Enable the Remote Backend

Now go to terraform root directory `backend.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-state-kkco-2025"
    key            = "simple-time-service/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

Then run:

```bash
terraform init
```

Terraform will ask to copy existing local state to the remote backend
 Say **yes**

---

### Step 3: From Now On — Use GitHub Actions

Your GitHub Actions workflow (e.g. `.github/workflows/deploy-terraform.yml`) will:

- Configure AWS credentials
- Initialize Terraform with the remote backend
- Plan and apply infra using the remote state

Example job snippet:

```yaml
- name: Terraform Init & Apply
  working-directory: ./simple-time-service-infra
  run: |
    terraform init
    terraform plan -out=tfplan
    terraform apply -auto-approve tfplan
```

---

##  Optional Cleanup

```bash
mv bootstrap-backend.tf bootstrap/
echo "bootstrap-backend.tf" >> .gitignore
```

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
