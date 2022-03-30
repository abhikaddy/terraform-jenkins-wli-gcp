terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~>3.53"
    }
  }
   backend "gcs" {
     bucket  = "<bucket name>"
     prefix = "<bucket prefix>"
     impersonate_service_account = "<SA to impersonate>"
   }
 }

locals {
 terraform_service_account = "<SA to impersonate>"
}

provider "google" {
 alias = "impersonation"
 scopes = [
   "https://www.googleapis.com/auth/cloud-platform",
   "https://www.googleapis.com/auth/userinfo.email",
 ]
}

data "google_service_account_access_token" "default" {
 provider               	= google.impersonation
 target_service_account 	= local.terraform_service_account
 scopes                 	= ["userinfo-email", "cloud-platform"]
 lifetime               	= "1200s"
}

provider "google" {
 access_token = data.google_service_account_access_token.default.access_token
}
