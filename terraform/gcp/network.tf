provider "google" {
  credentials = "${file("~/account.json")}"
  project     = "serverless-examples-193623"
  region      = "us-central1"
}

resource "google_compute_network" "default" {
  name                    = "us-central-1-network"
  auto_create_subnetworks = "true"
}
