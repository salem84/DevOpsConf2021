variable "build_folder" {
  type    = string
  default = "/image"
}

variable "capture_name_prefix" {
  type    = string
  default = "packer"
}

variable "commit_id" {
  type    = string
  default = "LATEST"
}

variable "helper_scripts" {
  type    = string
  default = "/image/scripts/helpers"
}

variable "metadata_file" {
  type    = string
  default = "/image/metadata.txt"
}

variable "scripts_folder" {
  type    = string
  default = "/image/scripts"
}

variable "toolset_json_path" {
  type    = string
  default = "${env("TEMP")}\\toolset.json"
}

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "docker" "ubuntudocker" {
  commit = true
  image  = "ubuntu:18.04"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.docker.ubuntudocker"]

  provisioner "shell" {
    inline = ["mkdir ${var.build_folder}", "mkdir ${var.scripts_folder}"]
  }

  provisioner "file" {
    destination = "${var.scripts_folder}"
    source      = "${path.root}/scripts/"
  }

  provisioner "shell" {
    environment_vars = ["METADATA_FILE=${var.metadata_file}", "HELPER_SCRIPTS=${var.helper_scripts}"]
    inline           = [
      "/image/scripts/base/basepackages.sh", 
      "/image/scripts/installers/7-zip.sh", 
      "/image/scripts/installers/azcopy.sh"
      ]
  }

  post-processor "docker-tag" {
    repository = "devopsconf.azurecr.io/ubuntu-agent-packer"
    tags = ["1.0"]
  }
}

