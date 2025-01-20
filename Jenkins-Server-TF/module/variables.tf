variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "civic-gate-439511-j2"
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "vpc-name" {
  description = "Name of the VPC"
  type        = string
  default     = "dev-gke-vpc"
}

variable "subnet-name" {
  description = "Name of the subnet"
  type        = string
  default     = "dev-gke-subnet"
}

variable "subnet-count" {
  description = "Number of subnets to create"
  type        = number
  default     = 3
}

variable "subnet-cidr-blocks" {
  description = "CIDR blocks for subnets"
  type        = list(string)
  default     = [
    "10.0.0.0/20",   # Primary subnet in us-central1-a
    "10.0.16.0/20",  # Primary subnet in us-central1-b
    "10.0.32.0/20"   # Primary subnet in us-central1-c
  ]
}

variable "pod-cidr-blocks" {
  description = "CIDR blocks for pods"
  type        = list(string)
  default     = [
    "10.48.0.0/14",  # Pod range for subnet 1
    "10.52.0.0/14",  # Pod range for subnet 2
    "10.56.0.0/14"   # Pod range for subnet 3
  ]
}

variable "svc-cidr-blocks" {
  description = "CIDR blocks for services"
  type        = list(string)
  default     = [
    "10.60.0.0/20",  # Service range for subnet 1
    "10.60.16.0/20", # Service range for subnet 2
    "10.60.32.0/20"  # Service range for subnet 3
  ]
}

variable "cluster-name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "dev-gke-cluster"
}

variable "cluster-version" {
  description = "Version of GKE cluster"
  type        = string
  default     = "1.27.3-gke.100"
}

variable "node_pools" {
  description = "List of node pool configurations"
  type = list(object({
    name         = string
    machine_type = string
    min_count    = number
    max_count    = number
    disk_size_gb = number
    spot         = bool
  }))
  default = [
    {
      name         = "general-pool"
      machine_type = "e2-standard-2"
      min_count    = 1
      max_count    = 5
      disk_size_gb = 100
      spot         = false
    },
    {
      name         = "spot-pool"
      machine_type = "e2-standard-4"
      min_count    = 0
      max_count    = 10
      disk_size_gb = 100
      spot         = true
    },
    {
      name         = "memory-pool"
      machine_type = "e2-highmem-4"
      min_count    = 1
      max_count    = 5
      disk_size_gb = 200
      spot         = false
    }
  ]
}
