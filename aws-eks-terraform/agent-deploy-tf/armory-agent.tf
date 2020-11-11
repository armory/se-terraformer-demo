provider "kubernetes" {
  host                   = https://DBF13B760BB32013D26D81DF17E7364A.sk1.us-west-2.eks.amazonaws.com
  cluster_ca_certificate = LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN5RENDQWJDZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJd01URXhNVEExTVRjeE1sb1hEVE13TVRFd09UQTFNVGN4TWxvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTlpaCkVGVUVWTElUZkpHemFiV0M2SWM2VHd4RkxldTRndGFSbTF5czFKL3F5Q1RTdk1ZaXR4R3hMU0kwRHcwbnZJYzAKQlRJSXVyckZQaUNNT0ZkanhiZWpDeHNMZ0tEYmg1YU4wLzFQVFlydHpxenFMcFJ0MFcxcm42SlZIV2d1dXA5WQpLMlBDbEltYzlqN2VhM2UyYmF6OUxzdGhINFo5TmE0dXhMQnd3WFlyang2MXN2ckY0cmtmeVYrelFoRDhQMWhUCjZkbjRWdk9CVWlSOGQ3Rnd0eFdwR2FSOVljcDNmeEdsZEtLU2E5NldNRXQzSEI4Qk5RZW02Q2FQTEIwOHNtdUQKTlI2azFnRCtjSjlMNnZvN2pZaUFkSHRLaHFpVTY2cE5ET0tGQ3RqTXZic3VwVVNpcGMycGp0cXY5M0RmTkFaVgpMZE4zNlUxRS9URWUzNDdEUmNzQ0F3RUFBYU1qTUNFd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFNQkViRGJ6MzJ5RlpwNmNCVzJnWmNVbXdzelgKRU1yMFN2eEZQTk5ZMXI1K1lrb01tam1Cbkxzc24xTDcvOVBXY05aQnpoVmtzNWR6blBWWmJjdXh6UXBJTExzSApUN3lLVE1FUTJpdTlXaHdPd1BKeXo2VVhma3hFOVNxRllWemdmQzJ5aHllRDRadWo5WitBWmdzMTlCMmdqRWlxCmMzUEgrUkVucFB1Y3laWlAzbGY4VGx5bWVKS0VGZDg1RmJ0Y0JRZTJMRDV1Y0hiU0thdnU4V0ZUcDVnL0ptcUwKRitvd0JPM0tOT3RLU1dvSVpBQ2gvS013dzRrUkgvamJlUjlTTnRMOW1jR0xUT0cwOGV2NzdUM1RjUERMMEUwZQpweE1Wa3JwMGg2YVZKSHJuWTkwQzlZNmx1ZEF6NmJJZ29YZ3dMOHJzaHhTSVRVbVFiV2k3YjJRcTVNWT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
  token                  = data.aws_eks_cluster_auth.example.token
  load_config_file       = false
}

resource "kubernetes_deployment" "spin_kubesvc" {
  metadata {
    name = "spin-kubesvc"
    labels = {
      app = "spin"
      "app.kubernetes.io/name" = "kubesvc"
      "app.kubernetes.io/part-of" = "spinnaker"
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
          "app.kubernetes.io/name" = "kubesvc"
          "app.kubernetes.io/part-of" = "spinnaker"
          cluster = "spin-kubesvc"
        }

        annotations = {
          "prometheus.io/path" = "/metrics"
          "prometheus.io/port" = "8008"
          "prometheus.io/scrape" = "true"
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

resource "kubernetes_service" "kubesvc_metrics" {
  metadata {
    name = "kubesvc-metrics"
    labels = {
      app = "spin"
      cluster = "spin-kubesvc"
    }
  }

  spec {
    port {
      name        = "metrics"
      protocol    = "TCP"
      port        = 8008
      target_port = "metrics"
    }

    selector = {
      app = "spin"
      cluster = "spin-kubesvc"
    }
  }
}
