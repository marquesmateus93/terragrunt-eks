# Terragrunt EKS

## About

The project creates an EKS cluster by consuming [Terraform EKS modules](https://github.com/marquesmateus93/terraform-eks).

## Core Components

### Addons

| Name                                                                                                                                                  | Description                                             |
|-------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| [ALB Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/)                                                              | Elastic Load Balancer Manager                           |
| [Cluster Autoscaler](https://github.com/kubernetes/autoscaler/tree/master/charts/cluster-autoscaler)                                                  | Cluster nodes size manager                              |
| [CSI](https://github.com/kubernetes-sigs/aws-ebs-csi-driver/tree/master/charts/aws-ebs-csi-driver)                                                    | Container EBS lifecycle manager                         |
| [Keda](https://github.com/kedacore/charts/tree/main/keda/templates)                                                                                   | Pod scaler Kubernetes workloads based                   |
| [MetaGPU](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/amazon-eks.html)                                                        | Share NVidia GPU resources between Kubernetes workloads |
| [Nginx Controller](https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx)                                                        | Ingress Controller                                      |
| [Secrets Store/CSI Driver](https://github.com/kubernetes-sigs/secrets-store-csi-driver/tree/main/charts/secrets-store-csi-driver)                     | Mount secrets into the pods as a volume                 |
| [Secrets Store/Secrets Manager](https://github.com/aws/secrets-store-csi-driver-provider-aws/tree/main/charts/secrets-store-csi-driver-provider-aws)  | Mount secrets into the pods as a volume                 |

## Auth

| Name        | Description                             |
|-------------|-----------------------------------------|
| Assume Role | Credentials provided by IAM             |
| SSO         | Credentials provided by Identity Center |

## Node Groups

| Name           | Description                                        |
|----------------|----------------------------------------------------|
| General        | For applications to be deployed onto the cluster   |
| GPU            | For applications GPU required resources            |
| Observability  | For observability tools(See Observability section) |

## Observability

| Name               | Description                                      |
|--------------------|--------------------------------------------------|
| CloudWatch Metrics | EKS metrics export for Cloud Watch               |
| Grafana            | Dashboard for Prometheus metrics                 |
| NVidia Exporter    | GPU metrics exporter                             |
| AWS OpenSearch     | Dashboards for LogStash logs containers exporter |
| Prometheus         | Kubernetes metrics exporter                      |
| SQL Exporter       | Database metrics exporter                        |

## Requirements

| Name       | Version |
|------------|---------|
| AWS CLI    | 2.19.0  |
| Terraform  | 1.5.5   |
| Terragrunt | 0.58.8  |
| Helm       | 3.16.2  |

## Structure

![VPC-EKS drawio](https://github.com/user-attachments/assets/5e5c7b57-1c92-452e-b00e-41fe70a14023)

