resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    command = <<-EOT
      kubectl kustomize \
        | sed "s/grpc_url_replace/${var.grpcurl}/g" \
        | sed "s/saas_spinnaker_account_replace/${var.account}-${var.env}-saas/g" \
        | kubectl apply --kubeconfig ../../accounts/saas-customers/${var.environmentId}/kubeconfig -f -
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}
