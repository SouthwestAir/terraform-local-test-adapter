# file: local/main.tf

# Check `./local/` directory for full configuration

module "root" {
  source = "../"

  context = module.root_labels.context

  # subscription
  create_subscription = var.create_subscription
  endpoint            = var.endpoint
}
