# # Kubernetes provider
# # https://learn.hashicorp.com/terraform/kubernetes/provision-eks-cluster#optional-configure-terraform-kubernetes-provider
# # To learn how to schedule deployments and services using the provider, go here: https://learn.hashicorp.com/terraform/kubernetes/deploy-nginx-kubernetes

provider "kubernetes" {
  load_config_file       = "false"
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

resource "null_resource" "install-agent" {
  count = 50
  provisioner "local-exec" {
    command = <<-EOT
      kubectl apply -f ./agent-deployment/serviceaccount.yaml \
      kubectl apply -f ./agent-deployment/deployment.yaml \
      kubectl apply -f ./agent-deployment/kubesvc.yaml
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}
