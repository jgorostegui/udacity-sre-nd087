# Udacity - Site Reliability Engineer Nanodegree

This repository contains the projects for the [Udacity SRE Nanodegree](https://www.udacity.com/course/site-reliability-engineer-nanodegree--nd087).

---

## Projects

### 1. [Observing Cloud Resources](./01-cd1898-Observing-Cloud-Resources/Project/README.md)

* **Goal:** Get hands-on with cloud observability.
* **Technologies:** Prometheus, Grafana, AWS EC2, EKS, Blackbox Exporter.
* **Key Tasks:**
  * Monitor AWS resources with Prometheus & Grafana.
  * Build dashboards for key metrics (CPU, Memory, etc.).
  * Set up API health checks and alerting.

### 2. [Planning for High Availability & Incident Response](./02-Planning-for-High-Availability-and-Incident-Response/project/README.md)

* **Goal:** Build a highly available, multi-zone architecture.
* **Technologies:** Terraform, AWS (Multi-Zone), RDS.
* **Key Tasks:**
  * Use Terraform to deploy infrastructure across multiple AWS zones.
  * Configure a resilient RDS cluster with a replica.
  * Define SLOs/SLIs and create a disaster recovery plan.

### 3. [Self-Healing Architectures](./03-self-healing-architectures/README.md)

* **Goal:** Implement self-healing systems on Kubernetes.
* **Technologies:** Kubernetes, Docker, Helm, Canary/Blue-Green.
* **Key Tasks:**
  * Execute Canary and Blue-Green deployment strategies.
  * Configure cluster auto-scaling for elastic workloads.
  * Troubleshoot and fix common Kubernetes deployment issues.

### 4. [Plan, Reduce, Repeat](./04-plan-reduce-repeat/)

* **Goal:** Simulate a real-world SRE work cycle.
* **Technologies:** Kubernetes, Prometheus, Bash/Python, GitHub Actions.
* **Key Tasks:**
  * Handle a simulated on-call week: respond to alerts, manage incidents.
  * Write a postmortem for a major outage.
  * Identify and automate operational toil.

---

## Common Setup

For detailed instructions, refer to the `README.md` inside each project folder. Common steps include:

* **Configure AWS CLI:** Ensure `aws configure` is set up with your credentials.
* **Setup Terraform Backend:** Use an S3 bucket for remote state management.
* **Deploy Infrastructure:** Run `terraform init` and `terraform apply`.
* **Connect to EKS:** Use `aws eks update-kubeconfig` to configure `kubectl`.

For a walkthrough on installing, configuring, and verifying the AWS CLI, refer to the provided [AWS Install and Configure CLI PDF](./tutorials/AWS-install-and-configure-cli.pdf).

### Environment Variables

```bash
export VERIFY_CHECKSUM=false
export TF_PLUGIN_CACHE_DIR="/tmp"
```

### Common Commands

**AWS Setup:**
```bash
aws configure  # Set up credentials
aws sts get-caller-identity  # Verify access
```

**Terraform Workflow:**
```bash
cd starter/infra
terraform init -upgrade
terraform plan
terraform apply -auto-approve
```

**Kubernetes Setup:**
```bash
aws eks --region us-east-2 update-kubeconfig --name udacity-cluster
kubectl config use-context arn:aws:eks:us-east-2:YOUR_ACCOUNT_ID:cluster/udacity-cluster
kubectl config set-context --current --namespace=udacity
```
