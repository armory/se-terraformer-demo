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
        | sed "s/saas_spinnaker_account_replace/${var.account}/g" -f -
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}
