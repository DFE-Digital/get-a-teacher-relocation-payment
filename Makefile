TERRAFILE_VERSION=0.8
ARM_TEMPLATE_TAG=1.1.0
RG_TAGS={"Product" : "International Relocation Payment"}
SERVICE_SHORT=trp

.PHONY: install-konduit
install-konduit: ## Install the konduit script, for accessing backend services
	[ ! -f bin/konduit.sh ] \
		&& curl -s https://raw.githubusercontent.com/DFE-Digital/teacher-services-cloud/master/scripts/konduit.sh -o bin/konduit.sh \
		&& chmod +x bin/konduit.sh \
		|| true

install-fetch-config:
	[ ! -f bin/fetch_config.rb ] \
		&& curl -s https://raw.githubusercontent.com/DFE-Digital/bat-platform-building-blocks/master/scripts/fetch_config/fetch_config.rb -o bin/fetch_config.rb \
		&& chmod +x bin/fetch_config.rb \
		|| true

review:
	$(if $(PR_NUMBER), , $(error Missing environment variable "PR_NUMBER", Please specify a pr number for your review app))
	$(eval include global_config/review.sh)
	$(eval DEPLOY_ENV=review)
	$(eval APP_NAME=pr-${PR_NUMBER})
	$(eval export TF_VAR_app_name=$(APP_NAME))
	echo https://teacher-relocation-payment-$(APP_NAME).test.teacherservices.cloud will be created in aks

qa:
	$(eval include global_config/qa.sh)
	$(eval DEPLOY_ENV=qa)

staging:
	$(eval include global_config/staging.sh)
	$(eval DEPLOY_ENV=staging)

production:
	$(eval include global_config/production.sh)
	$(eval DEPLOY_ENV=production)

ci:	## Run in automation environment
	$(eval DISABLE_PASSCODE=true)
	$(eval AUTO_APPROVE=-auto-approve)
	$(eval SP_AUTH=true)
	$(eval SKIP_AZURE_LOGIN=true)

install-terrafile: ## Install terrafile to manage terraform modules
	[ ! -f bin/terrafile ] \
		&& curl -sL https://github.com/coretech/terrafile/releases/download/v${TERRAFILE_VERSION}/terrafile_${TERRAFILE_VERSION}_$$(uname)_x86_64.tar.gz \
		| tar xz -C ./bin terrafile \
		|| true

set-azure-account:
	[ "${SKIP_AZURE_LOGIN}" != "true" ] && az account set -s ${AZ_SUBSCRIPTION} || true

terraform-init: install-terrafile set-azure-account
	$(if $(IMAGE_TAG), , $(eval export IMAGE_TAG=main))
	$(eval export TF_VAR_app_docker_image=ghcr.io/dfe-digital/international-teacher-relocation-payment:$(IMAGE_TAG))

	$(if $(APP_NAME), $(eval KEY_PREFIX=$(APP_NAME)), $(eval KEY_PREFIX=$(ENVIRONMENT)))
	./bin/terrafile -p terraform/aks/vendor/modules -f terraform/aks/config/$(CONFIG)_Terrafile
	terraform -chdir=terraform/aks init -upgrade -reconfigure \
		-backend-config=resource_group_name=${RESOURCE_GROUP_NAME} \
		-backend-config=storage_account_name=${STORAGE_ACCOUNT_NAME} \
		-backend-config=key=${KEY_PREFIX}.tfstate

	$(eval export TF_VAR_azure_resource_prefix=$(AZURE_RESOURCE_PREFIX))
	$(eval export TF_VAR_config_short=$(CONFIG_SHORT))
	$(eval export TF_VAR_service_short=$(SERVICE_SHORT))
	$(eval export TF_VAR_rg_name=$(RESOURCE_GROUP_NAME))

terraform-plan: terraform-init
	terraform -chdir=terraform/aks plan -var-file "config/${CONFIG}.tfvars.json"

terraform-apply: terraform-init
	terraform -chdir=terraform/aks apply -var-file "config/${CONFIG}.tfvars.json" $(AUTO_APPROVE)

terraform-destroy: terraform-init
	terraform -chdir=terraform/aks destroy -var-file "config/$(CONFIG).tfvars.json" $(AUTO_APPROVE)

read-tf-config:
	$(eval key_vault_name=$(shell jq -r '.key_vault_name' terraform/aks/config/$(DEPLOY_ENV).tfvars.json))
	$(eval key_vault_app_secret_name=$(shell jq -r '.key_vault_app_secret_name' terraform/aks/config/$(DEPLOY_ENV).tfvars.json))
	$(eval key_vault_infra_secret_name=$(shell jq -r '.key_vault_infra_secret_name' terraform/aks/config/$(DEPLOY_ENV).tfvars.json))
#	$(eval space=$(shell jq -r '.paas_space_name' terraform/aks/config/$(DEPLOY_ENV).tfvars.json))

read-cluster-config:
	$(eval CLUSTER=$(shell jq -r '.cluster' terraform/aks/config/$(DEPLOY_ENV).tfvars.json))
	$(eval NAMESPACE=$(shell jq -r '.namespace' terraform/aks/config/$(DEPLOY_ENV).tfvars.json))
	$(eval CONFIG_LONG=$(shell jq -r '.environment' terraform/aks/config/$(DEPLOY_ENV).tfvars.json))

edit-app-secrets: read-tf-config install-fetch-config set-azure-account
	bin/fetch_config.rb -s azure-key-vault-secret:${key_vault_name}/${key_vault_app_secret_name} \
		-e -d azure-key-vault-secret:${key_vault_name}/${key_vault_app_secret_name} -f yaml -c

edit-infra-secrets: read-tf-config install-fetch-config set-azure-account
	bin/fetch_config.rb -s azure-key-vault-secret:${key_vault_name}/${key_vault_infra_secret_name} \
		-e -d azure-key-vault-secret:${key_vault_name}/${key_vault_infra_secret_name} -f yaml -c

print-app-secrets: read-tf-config install-fetch-config set-azure-account
	bin/fetch_config.rb -s azure-key-vault-secret:${key_vault_name}/${key_vault_app_secret_name} -f yaml

print-infra-secrets: read-tf-config install-fetch-config set-azure-account
	bin/fetch_config.rb -s azure-key-vault-secret:${key_vault_name}/${key_vault_infra_secret_name} -f yaml

get-cluster-credentials: read-cluster-config set-azure-account ## make <config> get-cluster-credentials [ENVIRONMENT=<clusterX>]
	az aks get-credentials --overwrite-existing -g ${AZURE_RESOURCE_PREFIX}-tsc-${CLUSTER_SHORT}-rg -n ${AZURE_RESOURCE_PREFIX}-tsc-${CLUSTER}-aks
	kubelogin convert-kubeconfig -l $(if ${GITHUB_ACTIONS},spn,azurecli)

console: get-cluster-credentials
	$(if $(APP_NAME), $(eval export APP_ID=$(APP_NAME)) , $(eval export APP_ID=$(CONFIG_LONG)))
	kubectl -n ${NAMESPACE} exec -ti --tty deployment/teacher-relocation-payment-${APP_ID} -- /bin/sh -c "cd /app && /usr/local/bin/bundle exec rails c"

logs: get-cluster-credentials
	$(if $(APP_NAME), $(eval export APP_ID=$(APP_NAME)) , $(eval export APP_ID=$(CONFIG_LONG)))
	kubectl -n ${NAMESPACE} logs -l app=teacher-relocation-payment-${APP_ID} --tail=-1 --timestamps=true

ssh: get-cluster-credentials
	$(if $(APP_NAME), $(eval export APP_ID=$(APP_NAME)) , $(eval export APP_ID=$(CONFIG_LONG)))
	kubectl -n ${NAMESPACE} exec -ti --tty deployment/teacher-relocation-payment-${APP_ID} -- /bin/sh

set-what-if:
	$(eval WHAT_IF=--what-if)

arm-deployment: set-azure-account
	az deployment sub create --name "resourcedeploy-tsc-$(shell date +%Y%m%d%H%M%S)" \
		-l "UK South" --template-uri "https://raw.githubusercontent.com/DFE-Digital/tra-shared-services/${ARM_TEMPLATE_TAG}/azure/resourcedeploy.json" \
		--parameters "resourceGroupName=${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-${CONFIG_SHORT}-rg" 'tags=${RG_TAGS}' \
			"tfStorageAccountName=${AZURE_RESOURCE_PREFIX}${SERVICE_SHORT}tfstate${CONFIG_SHORT}sa" "tfStorageContainerName=terraform-state" \
			"keyVaultName=${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-${CONFIG_SHORT}-kv" ${WHAT_IF}

deploy-arm-resources: arm-deployment

validate-arm-resources: set-what-if arm-deployment

deploy-domain-resources: check-auto-approve domain-azure-resources # make dns set-what-if deploy-domain-resources AUTO_APPROVE=1

check-auto-approve:
	$(if $(AUTO_APPROVE), , $(error can only run with AUTO_APPROVE))

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

db-seed: get-cluster-credentials
	$(if $(APP_NAME), , $(error can only run with PR_NUMBER))
	kubectl -n ${NAMESPACE} exec deployment/teacher-relocation-payment-${APP_NAME} -- /bin/sh -c "cd /app && bundle exec rake db:version"

smoke-test: get-cluster-credentials
	$(if $(APP_NAME), $(eval export APP_ID=$(APP_NAME)) , $(eval export APP_ID=$(CONFIG_LONG)))
#	kubectl -n ${NAMESPACE} exec deployment/teacher-relocation-payment-${APP_ID} -- /bin/sh -c "RAILS_ENV=${CONFIG} bundle exec rspec spec/smoke"
	RAILS_ENV=${CONFIG} bin/rspec spec/requests/healthchecks_spec.rb"

printvar-%: ; @echo $($*)
