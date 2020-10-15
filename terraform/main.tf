resource "nomad_job" "adapt_web_parser_app_dev" {
  count    = terraform.workspace != "prod" ? 1 : 0
  provider = nomad.dev
  jobspec  = data.template_file.adapt_web_parser.rendered
}

resource "nomad_job" "adapt_web_parser_app_prod" {
  count    = terraform.workspace == "prod" ? 1 : 0
  provider = nomad.prod
  jobspec  = data.template_file.adapt_web_parser.rendered
}

data "template_file" "adapt_web_parser" {
  template = file("${path.module}/adapt-web-parser.hcl")

  vars = {
    adapt_web_parser_version   = var.adapt_web_parser_version
    auto_promote               = var.auto_promote
    canary_count               = var.group_canary_count
    adapt_web_parser_image_url = "${var.container_registry}/${var.adapt_web_parser_image}:${var.adapt_web_parser_version}"
    count                      = var.task_count
    cpu_units                  = var.adapt_web_parser_task_cpu_units
    env                        = var.environment
    mem_units                  = var.adapt_web_parser_task_mem_units
    vector_image_url           = var.vector_image_url
  }
}
