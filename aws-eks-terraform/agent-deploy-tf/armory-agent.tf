provider "kubernetes" {
  host                   = data.aws_eks_cluster.example.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.example.token
  load_config_file       = false
}

resource "null_resource" "install-agent" {
  provisioner "local-exec" {
    command = <<-EOT
      kustomize build ../agent-deployment \
        | sed "s/account_name_replace/account_name_replace/g" \
        | kubectl apply --kubeconfig ../kubecfgs/kubecfg-demo.yaml -f -
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
  depends_on = [
    null_resource.get-credentials,
  ]
}
