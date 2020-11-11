provider "kubernetes" {
  host                   = ${cluster_endpoint}
  cluster_ca_certificate = ${kubectl_config}
  token                  = ${config_map_aws_auth}
  load_config_file       = false
}

resource "kubernetes_deployment" "spin_kubesvc" {
  metadata {
    name = "spin-kubesvc"

    labels = {
      app = "spin"
      app.kubernetes.io/name = "kubesvc"
      app.kubernetes.io/part-of = "spinnaker"
      cluster = "spin-kubesvc"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "spin"
        cluster = "spin-kubesvc"
      }
    }
    template {
      metadata {
        labels = {
          app = "spin"
          app.kubernetes.io/name = "kubesvc"
          app.kubernetes.io/part-of = "spinnaker"
          cluster = "spin-kubesvc"
        }
        annotations = {
          prometheus.io/path = "/metrics"
          prometheus.io/port = "8008"
          prometheus.io/scrape = "true"
        }
      }
      spec {
        volume {
          name = "volume-kubesvc-config"
          config_map {
            name = "kubesvc-config"
          }
        }
        container {
          name  = "kubesvc"
          image = "armory/kubesvc"

          port {
            name           = "health"
            container_port = 8082
            protocol       = "TCP"
          }

          port {
            name           = "metrics"
            container_port = 8008
            protocol       = "TCP"
          }

          volume_mount {
            name       = "volume-kubesvc-config"
            mount_path = "/opt/spinnaker/config"
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = "health"
            }

            timeout_seconds   = 1
            period_seconds    = 10
            success_threshold = 1
            failure_threshold = 3
          }

          termination_message_path = "/dev/termination-log"
          image_pull_policy        = "IfNotPresent"
        }

        restart_policy       = "Always"
        service_account_name = "spin-sa"
      }
    }
  }
}
