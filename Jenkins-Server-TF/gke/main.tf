locals {
  org = "medium"
  env = "dev"
}

module "gke" {
  source = "../module"

  project_id         = var.project_id
  region            = var.region
  vpc-name          = "${local.env}-${local.org}-${var.vpc-name}"
  subnet-name       = "${local.env}-${local.org}-${var.subnet-name}"
  subnet-count      = var.subnet-count
  subnet-cidr-blocks = var.subnet-cidr-blocks
  pod-cidr-blocks   = var.pod-cidr-blocks
  svc-cidr-blocks   = var.svc-cidr-blocks
  cluster-name      = "${local.env}-${local.org}-${var.cluster-name}"
  cluster-version   = var.cluster-version
  node_pools        = var.node_pools
}