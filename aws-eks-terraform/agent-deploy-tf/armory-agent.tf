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
