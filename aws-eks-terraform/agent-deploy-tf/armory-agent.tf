provider "kubernetes" {
  host                   = data.aws_eks_cluster.example.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.example.token
  load_config_file       = false
}

"apiVersion" = "apps/v1"
"kind" = "Deployment"
"metadata" = {
  "labels" = {
    "app" = "spin"
    "app.kubernetes.io/name" = "kubesvc"
    "app.kubernetes.io/part-of" = "spinnaker"
    "cluster" = "spin-kubesvc"
  }
  "name" = "spin-kubesvc"
}
"spec" = {
  "replicas" = 1
  "selector" "matchLabels" {
    "app" = "spin"
    "cluster" = "spin-kubesvc"
  }
  "template" "metadata" "labels" {
    "app" = "spin"
    "app.kubernetes.io/name" = "kubesvc"
    "app.kubernetes.io/part-of" = "spinnaker"
    "cluster" = "spin-kubesvc"
  }
  "template" "metadata" "annotations" {
    "prometheus.io/scrape" = "true"
    "prometheus.io/path" = "/metrics"
    "prometheus.io/port" = "8008"
  }
  "template" "spec" {
    "serviceAccountName" = "spin-sa"
    "containers" = {
      "image" = "armory/kubesvc"
      "imagePullPolicy" = "IfNotPresent"
      "name" = "kubesvc"
      "ports" = {
        "name" = "health"
        "containerPort" = 8082
        "protocol" = "TCP"
      }
      "ports" = {
        "name" = "metrics"
        "containerPort" = 8008
        "protocol" = "TCP"
      }
      "readinessProbe" = {
        "httpGet" = {
          "port" = "health"
          "path" = "/health"
        }
        "failureThreshold" = 3
        "periodSeconds" = 10
        "successThreshold" = 1
        "timeoutSeconds" = 1
      }
      "terminationMessagePath" = "/dev/termination-log"
      "terminationMessagePolicy" = "File"
      "volumeMounts" = {
        "mountPath" = "/opt/spinnaker/config"
        "name" = "volume-kubesvc-config"
      }
    }
    "restartPolicy" = "Always"
    "volumes" = {
      "name" = "volume-kubesvc-config"
      "configMap" = {
        "name" = "kubesvc-config"
      }
    }
  }
}
