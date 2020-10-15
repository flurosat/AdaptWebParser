provider "nomad" {
  alias   = "dev"
  address = "https://nomad-api.dev.flurosense.io"
}

provider "nomad" {
  alias   = "prod"
  address = "https://nomad-api.prod.flurosense.io"
}

