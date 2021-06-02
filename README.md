# Terraformer #
Please look at official [README](https://github.com/GoogleCloudPlatform/terraformer) for documentation.<br />
<br />
This container is just a build of Terraformer inside an alpine image.<br />
This is built at every commit on the master branch of Terraformer.

# How to use it? #

Example with the PAN-OS provider.

## Generate HCL files ##
```sh
$ cat > provider.tf << EOF
terraform {
  required_providers {
    panos = {
      source = "PaloAltoNetworks/panos"
    }
  }
  required_version = ">= 0.13"
}
EOF
$ terraform init
$ docker run --rm \
    -e PANOS_HOSTNAME=192.168.1.1 \
    -e PANOS_USERNAME=admin \
    -e PANOS_PASSWORD=admin \
    -v $(pwd)/.terraform:/root/.terraform \
    -v $(pwd)/.terraform.d:/root/.terraform.d \
    -v $(pwd)/generated:/root/generated \
    troissixzero/terraformer:latest import panos -r device_config
```

## Convert provider.tf and tfstate to Terraform > 0.13 ##
```sh
$ cd generated/panos/vsys1/device_config
$ cp ../../../../provider.tf provider.tf
$ terraform state replace-provider -auto-approve registry.terraform.io/-/panos PaloAltoNetworks/panos
```
