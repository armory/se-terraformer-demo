resource "null_resource" "install-agent" {
  count = 50
  provisioner "local-exec" {
    command = <<-EOT
      kubectl apply --kubeconfig ../kubecfgs/serviceaccount.yaml
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}
