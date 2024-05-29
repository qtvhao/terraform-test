resource "random_id" "samba_password" {
  byte_length = 8
}
locals {
  samba_password = random_id.samba_password.hex
}

resource "kubernetes_deployment_v1" "samba-test" {
  metadata {
    name = "samba-test"
    labels = {
      "io.kompose.service" = "samba-test"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "io.kompose.service" = "samba-test"
      }
    }
    strategy {
      type = "Recreate"
    }
    template {
      metadata {
        labels = {
          "io.kompose.network/samba-samba" = "true"
          "io.kompose.service"             = "samba-test"
        }
      }
      spec {
        container {
          env {
            name  = "GID"
            value = "1000"
          }
          env {
            name  = "PASS"
            value = local.samba_password
          }
          env {
            name  = "UID"
            value = "1000"
          }
          env {
            name  = "USER"
            value = "samba"
          }
          image = "dockurr/samba"
          name  = "samba"
          volume_mount {
            mount_path = "/storage"
            name       = "samba-claim0"
          }
        }

        volume {
          name = "samba-claim0"
          host_path {
            path = "/samba-claim0/"
            type = "DirectoryOrCreate"
          }
        }
        restart_policy = "Always"
      }
    }

  }
}
