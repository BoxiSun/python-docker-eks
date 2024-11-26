################################################################################
# ALB controller
################################################################################
resource "kubernetes_service_account_v1" "service-account" {
 metadata {
     name      = "aws-load-balancer-controller"
     namespace = "kube-system"
     labels = {
     "app.kubernetes.io/name"      = "aws-load-balancer-controller"
     "app.kubernetes.io/component" = "controller"
     }
     annotations = {
     "eks.amazonaws.com/role-arn"               = data.aws_iam_role.lb_role.arn
     "eks.amazonaws.com/sts-regional-endpoints" = "true"
     }
 }
 }

resource "helm_release" "alb-controller" {
 name       = "aws-load-balancer-controller"
 repository = "https://aws.github.io/eks-charts"
 chart      = "aws-load-balancer-controller"
 namespace  = "kube-system"
 depends_on = [
     kubernetes_service_account_v1.service-account
 ]

 set {
     name  = "region"
     value = var.region
 }

 set {
     name  = "vpcId"
     value = data.aws_vpc.test-vpc.id
 }

 set {
     name  = "image.repository"
     value = "602401143452.dkr.ecr.${var.region}.amazonaws.com/amazon/aws-load-balancer-controller"
 }

 set {
     name  = "serviceAccount.create"
     value = "false"
 }

 set {
     name  = "serviceAccount.name"
     value = "aws-load-balancer-controller"
 }

 set {
     name  = "clusterName"
     value = "${var.app_name}-eks-cluster"
 }
}

################################################################################
# Flask Namespace
################################################################################

resource "kubernetes_namespace_v1" "flask-namespace" {
  metadata {
    annotations = {
      name = var.app_name
    }

    labels = {
      application = var.app_name
    }

    name = var.app_name
  }
}

################################################################################
# Flask Service Account
################################################################################

resource "kubernetes_service_account_v1" "service-account-flask" {
  metadata {
    name      = "${var.app_name}-sa"
    namespace = kubernetes_namespace_v1.flask-namespace.metadata[0].name
    labels = {
      "app.kubernetes.io/name" = "${var.app_name}-sa"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = data.aws_iam_role.app_role.arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

################################################################################
# Flask Deployment
################################################################################

resource "kubernetes_deployment_v1" "flask_deployment" {
  metadata {
    name      = "${var.app_name}-deployment"
    namespace = kubernetes_namespace_v1.flask-namespace.id
    labels = {
      app = "${var.app_name}"
    }
  }

  spec {
    replicas = var.num_of_replicas

    selector {
      match_labels = {
        app = "${var.app_name}"
      }
    }

    template {
      metadata {
        labels = {
          app = "${var.app_name}"
        }
      }
      spec {
        service_account_name = kubernetes_service_account_v1.service-account-flask.metadata[0].name
        
        #NOTE:image_pull_secrets is for private images. It requires the eks secrets to be created. The manifect can be found in the folder "pull_image_secret"
        # image_pull_secrets {
        #     name = "${var.app_name}-image-pull-credential"
        # }
        
        container {
          image = "${var.image}:${var.image_version}"
          name  = "${var.app_name}"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          port {
            container_port = 5000
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 5000

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 10
            period_seconds        = 10
          }
        }
      }
    }
  }
}

################################################################################
# Flask Service
################################################################################

resource "kubernetes_service_v1" "flask_svc" {
  metadata {
    name      = "${var.app_name}-svc"
    namespace = kubernetes_namespace_v1.flask-namespace.metadata[0].name
  }
  spec {
    selector = {
      app = "${var.app_name}"
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 5000
    }

    type = "NodePort"
  }
}

################################################################################
# Flask Ingress
################################################################################

resource "kubernetes_ingress_v1" "flask_ingress" {
  depends_on = [helm_release.alb-controller]
  metadata {
    name      = "${var.app_name}-ingress"
    namespace = kubernetes_namespace_v1.flask-namespace.metadata[0].name
    annotations = {
      "alb.ingress.kubernetes.io/load-balancer-name" = "${var.app_name}-alb"
      "alb.ingress.kubernetes.io/scheme" = "internal"
      "alb.ingress.kubernetes.io/subnets" = "${data.aws_subnets.private_all_az.ids[0]}, ${data.aws_subnets.private_all_az.ids[1]}"
      "alb.ingress.kubernetes.io/certificate-arn" = data.aws_acm_certificate.default.arn
      "alb.ingress.kubernetes.io/ssl-redirect" = 443
      "alb.ingress.kubernetes.io/listen-ports" = <<JSON
        [
            {"HTTP": 80},
            {"HTTPS": 443}
        ]
        JSON
    }
  }

  wait_for_load_balancer = "true"

  spec {
    ingress_class_name = "alb"

    rule {
      http {
        path {
          backend {
            service {
              #name = "${var.app_name}-svc"
              name = kubernetes_service_v1.flask_svc.metadata[0].name
              port {
                number = 80
              }
            }
          }

          path = "/*"
        }

      }
    }

    tls {
      secret_name = "tls-secret"
    }
  }
}

################################################################################
# Flask RBAC
################################################################################

resource "kubernetes_role_v1" "flask_rbac_role" {
  metadata {
    name = "${var.app_name}_rbac_role"
    labels = {
      app = "${var.app_name}"
    }
    namespace = kubernetes_namespace_v1.flask-namespace.metadata[0].name
  }
  rule {
    api_groups     = [""]
    resources      = ["pods"]
    verbs          = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["services"]
    verbs      = ["get", "list"]
  }
}

resource "kubernetes_role_binding_v1" "flask_rbac_role_binding" {
  metadata {
    name      = "${var.app_name}-role-binding"
    namespace = kubernetes_namespace_v1.flask-namespace.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.flask_rbac_role.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.service-account-flask.metadata[0].name
    namespace = kubernetes_namespace_v1.flask-namespace.metadata[0].name
  }
}