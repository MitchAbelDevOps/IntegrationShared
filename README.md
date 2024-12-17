# azure-shared-infrastructure
This repo contains Terraform code for deploying common/shared infrastructure to Azure, primarily for the purpose of the Azure Landing Zone.


## Workflows:
This repo contains a workflow per resource which will target the Terraform under the folder for that resource.

There is also a workflow to called .infra-rg-{resourceGroupName}-mitchtest-orchestration-workflow.yaml. This worfklow calls other workflows in the repo in the pre-determined order required to deploy the resource group correctly.