variable "grpcurl" {
  default = "host-clouddriver.plugin.fqdn.com"
}

variable "account" {
  default = "k8s-account"
}

variable "kubeconfig" {
  default = "kubeconfig_default"
}

resource "local_file" "kubeconfig" {
    content     = var.kubeconfig
    filename = "${path.module}/kubeconfig"
}

resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    command = <<-EOT
      kubectl kustomize \
        | sed "s/grpc_url_replace/${var.grpcurl}/g" \
        | sed "s/spinnaker_account_replace/${var.account}/g" | kubectl --kubeconfig ${local_file.kubeconfig.filename} apply -f -
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}
