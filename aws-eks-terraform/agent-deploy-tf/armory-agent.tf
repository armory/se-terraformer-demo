resource "null_resource" "install-agent" {
  provisioner "local-exec" {
    command = <<-EOT
      kubectl apply -k ../agent-deployment/
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}
