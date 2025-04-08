TERRAFILE_VERSION=0.8
ARM_TEMPLATE_TAG=1.1.0
RG_TAGS={"Product" : "International Relocation Payment"}
SERVICE_SHORT=trp

qa:
	$(eval include global_config/qa.sh)
	$(eval DEPLOY_ENV=qa)

staging:
	$(eval include global_config/staging.sh)
	$(eval DEPLOY_ENV=staging)

production:
	$(eval include global_config/production.sh)
	$(eval DEPLOY_ENV=production)

set-azure-account:
	az account set -s ${AZ_SUBSCRIPTION}

dns:
	$(eval include global_config/dns-domain.sh)

domains-infra-init: set-azure-account
	terraform -chdir=terraform/custom_domains/infrastructure init -reconfigure -upgrade \
		-backend-config=config/${DOMAINS_ID}_backend.tfvars

domains-infra-plan: domains-infra-init # make dns domains-infra-plan
	terraform -chdir=terraform/custom_domains/infrastructure plan -var-file config/${DOMAINS_ID}.tfvars.json

domains-infra-apply: domains-infra-init # make dns domains-infra-apply
	terraform -chdir=terraform/custom_domains/infrastructure apply -var-file config/${DOMAINS_ID}.tfvars.json ${AUTO_APPROVE}

domains-init: set-azure-account
	$(if $(PR_NUMBER), $(eval DEPLOY_ENV=${PR_NUMBER}))
	terraform -chdir=terraform/custom_domains/environment_domains init -upgrade -reconfigure -backend-config=config/${DOMAINS_ID}_${DEPLOY_ENV}_backend.tfvars

domains-plan: domains-init  # make qa dns domains-plan
	terraform -chdir=terraform/custom_domains/environment_domains plan -var-file config/${DOMAINS_ID}_${DEPLOY_ENV}.tfvars.json

domains-apply: domains-init # make qa dns domains-apply
	terraform -chdir=terraform/custom_domains/environment_domains apply -var-file config/${DOMAINS_ID}_${DEPLOY_ENV}.tfvars.json ${AUTO_APPROVE}

domains-destroy: domains-init # make qa dns domains-destroy
	terraform -chdir=terraform/custom_domains/environment_domains destroy -var-file config/${DOMAINS_ID}_${DEPLOY_ENV}.tfvars.json

domain-azure-resources: set-azure-account
	$(if $(AUTO_APPROVE), , $(error can only run with AUTO_APPROVE))
	az deployment sub create -l "UK South" --template-uri "https://raw.githubusercontent.com/DFE-Digital/tra-shared-services/${ARM_TEMPLATE_TAG}/azure/resourcedeploy.json" \
		--name "${DNS_ZONE}domains-$(shell date +%Y%m%d%H%M%S)" --parameters "resourceGroupName=${RESOURCE_NAME_PREFIX}-${DNS_ZONE}domains-rg" 'tags=${RG_TAGS}' \
			"tfStorageAccountName=${RESOURCE_NAME_PREFIX}${DNS_ZONE}domainstf" "tfStorageContainerName=${DNS_ZONE}domains-tf"  "keyVaultName=${RESOURCE_NAME_PREFIX}-${DNS_ZONE}domains-kv" ${WHAT_IF}
