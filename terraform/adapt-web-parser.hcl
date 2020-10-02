job "adapt-web-parser-${env}" {
  datacenters = [
    "australia-southeast1-a",
    "australia-southeast1-b",
    "australia-southeast1-c",
  ]

  group "service" {
    count = ${count}

    update {
      max_parallel     = 1
      canary           = ${canary_count}
      min_healthy_time = "60s"
      healthy_deadline = "300s"
      auto_revert      = true
      auto_promote     = ${auto_promote}
    }

    task "vector" {

      driver = "docker"

      resources {
        cpu = 100
        memory = 128
      }


      config {
        image = "${vector_image_url}"

        volumes = [
          "secret/credentials.json:/etc/vector/credentials.json",
          "local/vector.toml:/etc/vector/vector.toml:ro",
        ]
      }

      template {
        data = <<EOH
{{key "svc/vector/iam/gcp-service-account"}}
EOH
        destination = "secret/credentials.json"
      }

      template {
        data = <<VECTORCFG
data_dir = "/tmp"

[sources.in]
  type = "file"
  include = [
    "/alloc/logs/adapt-web-parser*",
    "/alloc/logs/vector.*"
  ]

[sinks.out]
  type = "gcp_stackdriver_logs"
  inputs = ["in"]
  credentials_path = "/etc/vector/credentials.json"
  log_id = "adapt-web-parser-${env}-vector-logs"
  project_id = "flurosat-154904"
  resource.type = "gce_instance"
  resource.zone = "$${NOMAD_DC}"
  resource.instance_id = "$${NOMAD_ALLOC_ID}"

VECTORCFG
        destination = "local/vector.toml"
      }
    }

    task "adapt-web-parser-${env}" {
      driver = "docker"
      config {
        image = "${adapt_web_parser_image_url}"
        port_map {
          http = 8080
        }
      }

      resources {
        cpu = ${cpu_units}
        memory = ${mem_units}
        network {
          port "http" {}
        }
      }

      service {
        name = "adapt-web-parser-${adapt_web_parser_version}"
        port = "http"

        tags = [
          "traefik.http.middlewares.adapt-web-parser-${adapt_web_parser_version}-stripprefix.stripprefix.prefixes=/adapt-web-parser",
          "traefik.http.routers.adapt-web-parser-${adapt_web_parser_version}.entrypoints=http",
          "traefik.http.routers.adapt-web-parser-${adapt_web_parser_version}.middlewares=adapt-web-parser-${adapt_web_parser_version}-stripprefix",
          "traefik.http.routers.adapt-web-parser-${adapt_web_parser_version}.rule=Host(`a.${env}.flurosense.io`, `a.${env}.flurosense.com`)&&PathPrefix(`/adapt-web-parser`)",
          "version=${adapt_web_parser_version}",
        ]

        check {
          type     = "tcp"
          port     = "http"
          interval = "15s"
          timeout  = "1s"
        }
      }
    }
  }
}
