terraform {
  backend "gcs" {
    bucket = "flurosat-australia-southeast1-ops-terraform"
    prefix = "svc/adapt-web-parser"
  }
}

