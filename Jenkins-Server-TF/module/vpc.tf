resource "google_compute_network" "vpc" {
  name                    = var.vpc-name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  count         = var.subnet-count
  name          = "${var.subnet-name}-${count.index + 1}"
  network       = google_compute_network.vpc.id
  region        = var.region
  ip_cidr_range = element(var.subnet-cidr-blocks, count.index)

  secondary_ip_range {
    range_name    = "pods-range-${count.index + 1}"
    ip_cidr_range = element(var.pod-cidr-blocks, count.index)
  }

  secondary_ip_range {
    range_name    = "services-range-${count.index + 1}"
    ip_cidr_range = element(var.svc-cidr-blocks, count.index)
  }
}

resource "google_compute_router" "router" {
  name    = "${var.vpc-name}-router"
  network = google_compute_network.vpc.id
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.vpc-name}-nat"
  router                            = google_compute_router.router.name
  region                            = var.region
  nat_ip_allocate_option            = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_firewall" "allow-internal" {
  name    = "${var.vpc-name}-allow-internal"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = var.subnet-cidr-blocks
}