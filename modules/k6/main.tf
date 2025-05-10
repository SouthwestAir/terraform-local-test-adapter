locals {
  log_folder = abspath(path.module)
  k6_opts    = "--out json=${local.log_folder}/k6.json"
}
resource "null_resource" "run_k6" {
  provisioner "local-exec" {
    environment = var.env_vars
    working_dir = var.working_dir
    command     = <<EOT
      rm -f ${local.log_folder}/k6.log;
      rm -f ${local.log_folder}/k6.json;
      k6 run ${local.k6_opts} script.k6.js 2>&1 | tee ${local.log_folder}/k6.log
    EOT
  }
}
data "local_file" "k6_log" {
  depends_on = [null_resource.run_k6]
  filename   = "${local.log_folder}/k6.log"
  lifecycle {
    postcondition {
      condition     = length(self.content) > 0
      error_message = "k6 log should not be empty"
    }
  }
}
