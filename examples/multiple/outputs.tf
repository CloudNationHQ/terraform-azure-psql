output "instances" {
  value = {
    for inst_name, inst_config in local.instances : inst_name => {
      name = inst_config.name
    }
  }
}
