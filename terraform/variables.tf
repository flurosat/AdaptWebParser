variable "auto_promote" {
  description = "Automatically promote the canary deployment"
  type        = bool
  default     = true
}

variable "container_registry" {
  type    = string
  default = "australia-southeast1-docker.pkg.dev/flurosat-154904/flurosat"
}

variable "adapt_web_parser_version" {
  type    = string
  default = "latest"
}

variable "adapt_web_parser_image" {
  type    = string
  default = "adapt-web-parser"
}

variable "vector_image_url" {
  type    = string
  default = "timberio/vector:0.9.X-alpine"
}

variable "environment" {
  type = string
}

variable "adapt_web_parser_task_cpu_units" {
  type    = number
  default = 100
}

variable "adapt_web_parser_task_mem_units" {
  type    = number
  default = 500
}

variable "task_count" {
  type    = number
  default = 1
}

variable "group_canary_count" {
  type    = number
  default = 1
}
