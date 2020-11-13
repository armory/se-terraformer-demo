resource "null_resource" "install-agent" {
  count = 50
  provisioner "local-exec" {
    command = <<-EOT
      kubectl apply -f ./agent-deployment/serviceaccount.yaml
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}
