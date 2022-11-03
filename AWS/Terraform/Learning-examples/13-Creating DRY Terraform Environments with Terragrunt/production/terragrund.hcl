# Collect values from environment_vars.yaml and set as local variables
locals {
  env_vars = yamldecode(file("environment_vars.yaml"))
}