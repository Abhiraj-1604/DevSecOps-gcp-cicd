project_id         = "civic-gate-439511-j2"
region             = "us-central1"
vpc_name           = "dev-gke-vpc"
subnet_name        = "dev-gke-subnet"
subnet_count       = 3
subnet_cidr_blocks = [
  "10.0.0.0/20",   # Primary subnet in us-central1-a
  "10.0.16.0/20",  # Primary subnet in us-central1-b
  "10.0.32.0/20"   # Primary subnet in us-central1-c
]
pod_cidr_blocks    = [
  "10.48.0.0/14",  # Pod range for subnet 1
  "10.52.0.0/14",  # Pod range for subnet 2
  "10.56.0.0/14"   # Pod range for subnet 3
]
svc_cidr_blocks    = [
  "10.60.0.0/20",  # Service range for subnet 1
  "10.60.16.0/20", # Service range for subnet 2
  "10.60.32.0/20"  # Service range for subnet 3
]
cluster_name       = "dev-gke-cluster"
cluster_version    = "1.27.3-gke.100"

node_pools = [
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

addons = [
  {
    name    = "vpc-cni"
    version = "enabled" # In GKE, enable Dataplane V2 for advanced networking
  },
  {
    name    = "coredns"
    version = "managed" # CoreDNS is built into GKE and automatically managed
  },
  {
    name    = "kube-proxy"
    version = "managed" # kube-proxy is pre-installed and tied to the Kubernetes version
  },
  {
    name    = "gce-pd-csi-driver"
    version = "enabled" # Equivalent to AWS EBS CSI driver for managing GCE Persistent Disks
  }
  # Add more addons or integrations as needed
]

# Enable additional GKE features
enable_dataplane_v2 = true                  # Advanced networking (VPC CNI equivalent)
enable_gce_pd_csi_driver = true             # GCE Persistent Disk CSI Driver
enable_shielded_nodes = true                # Enhanced node security
enable_private_nodes = true                 # Private cluster
enable_autoscaling = true                   # Cluster autoscaling
