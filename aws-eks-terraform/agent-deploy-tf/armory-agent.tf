resource "null_resource" "install-agent" {
  provisioner "local-exec" {
    command = <<-EOT
      kustomize build ../agent-deployment | kubectl apply -f -
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}
