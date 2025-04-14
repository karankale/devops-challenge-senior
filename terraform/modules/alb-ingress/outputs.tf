output "alb_dns_name" {
  description = "Public DNS name of the ALB Ingress"
  value       = kubernetes_ingress_v1.alb.status[0].load_balancer[0].hostname
}
