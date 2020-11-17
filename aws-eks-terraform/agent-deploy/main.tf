provider "kubernetes" {
  load_config_file       = "false"
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

variable "grpcurl" {
  default = "host-clouddriver.plugin.fqdn.com"
}

variable "account" {
  default = "k8s-account"
}

resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    command = <<-EOT
      kubectl kustomize \
        | sed "s/grpc_url_replace/${var.grpcurl}/g" \
        | sed "s/saas_spinnaker_account_replace/${var.account}/g" | kubectl --kubeconfig ${module.eks.kubeconfig} apply -f -
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}
