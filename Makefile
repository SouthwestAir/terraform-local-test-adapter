### -------------------------------------------------------------------------------------------------------------------------------
### Source: https://southwest.gitlab-dedicated.com/swa-common/devplat/ccp-next/ccp-next-templates/ccp-next-module-template/-/tree/master/Makefile
### ---
### This is the local Makefile for Terraform module project.
### ---
### Run `make setup` to configure this project and your local dev environment.
### ---
### When configured all make targets will be forwarded to `.general-resources.mk` which is maintained by CCP.
### Check those recipes for more details.
### ---
### Run `make help` to list all recipes.
### ---
### You are free to override any of the targets for a custom pipeline but is absolutely NOT recommended to
### override any targets. CCP intends all teams to use the default targets to close the gaps between pipelines and
### and local deployments with built in best practices.
### ---
### If for some reason your project is broken for upstream changes you can set your artifact version (nexus url)
### in the `setup-local` target to a previous working version and let CCP know of the issue. CCP will make every
### effort to avoid introducing breaking changes to upstream resources without a Major version.
### It is recommended to use the latest resources from upstream to get the latest and greatest from CCP and hence
### the nexus url is not set to a specific version.
### ---
### Variables:
### 	- GENERAL_RESOURCES_CACHING_ENABLED:
### 		- When enabled, will reuse cached general resources (pinned version) if cache is found.
### 		- Defaults to "true" in CI/CD pipelines.
### 		- Set any other value or unset the variable to disable caching.
### 		- Enabling this ensures that each pipeline run uses a consistent, versioned general resources artifact,
### 		  even on reruns. Fresh pipelines will fetch the latest artifact initially, and use that version for
### 		  all subsequent jobs within the same pipeline run.
### 		- NOT recommended to set it for local.
### 	- GENERAL_RESOURCES_MAJOR_VERSION:
### 		- Define specific major version of general resources to use, for e.g. `0` for `0.x` or `1` for `1.x`.
### 		- Defaults to `0`
### 	- GENERAL_RESOURCES_VERSION:
### 		- Define specific version of general resources to use. E.g. `0.10.0`.
### 		- Defaults to latest artifact version
### 	- GENERAL_RESOURCES_URL:
### 		- Override artifact download URL.
### 		- E.g. URL for using `0.10.0` artifact (`$GENERAL_RESOURCES_VERSION` can achieve the same goal without defining the whole URL):
### 			https://nexus-tools.swacorp.com/service/rest/v1/search/assets/download?repository=releases&group=com.swacorp.ccplat.swa-common.devplat.ccp-next&name=ccp-next-general-resources&maven.extension=zip&version=0.10.0
### 		- E.g. URL for a snapshots:
### 			https://nexus-tools.swacorp.com/repository/snapshots/com/swacorp/ccplat/swa-common/devplat/ccp-next/ccp-next-general-resources-feat-guard-175-add-helm-deploy/SNAPSHOT/ccp-next-general-resources-feat-guard-175-add-helm-deploy-20241212.233701-1-feat-guard-175-add-helm-deploy.zip
### -------------------------------------------------------------------------------------------------------------------------------
#

SHELL := /bin/bash

# # you can use this if it helps with `renovate` configuration
# GENERAL_RESOURCES_URL ?= https://nexus-tools.swacorp.com/service/rest/v1/search/assets/download?repository=releases&group=com.swacorp.ccplat.swa-common.devplat.ccp-next&name=ccp-next-general-resources&maven.extension=zip&version=0.10.0

.PHONY: help
help: ## show this message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage: make \033[36m<target>\033[0m\n\n"} \
		/^###/ {sub(/^### /, ""); description = description $$0 "\n"} \
		/^[a-zA-Z_-]+:.*##/ { \
			printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2 \
		} \
		END { printf "\n%s", description }' $(MAKEFILE_LIST)
	@if [[ -f .general-resources.mk ]]; then \
		$(MAKE) --no-print-directory -f .general-resources.mk help; \
	fi

setup: FORCE setup-local ## setup development environment
	@$(MAKE) --no-print-directory -f .general-resources.mk setup;

setup-local: FORCE ## setup local environment by downloading ccp-next-general-resources
	@if [ ! -d .general-resources ] || [ "$$GENERAL_RESOURCES_CACHING_ENABLED" != "true" ]; then \
		echo "Fetching general resources artifact from Nexus..."; \
		rm -rf .general-resources && mkdir -p .general-resources; \
		if [ -z $$GENERAL_RESOURCES_URL ]; then \
			GENERAL_RESOURCES_MAJOR_VERSION="$${GENERAL_RESOURCES_MAJOR_VERSION:-0}"; \
			artifact_version="$${GENERAL_RESOURCES_VERSION:-$$(curl -s 'https://nexus-tools.swacorp.com/service/rest/v1/search?repository=releases&group=com.swacorp.ccplat.swa-common.devplat.ccp-next&name=ccp-next-general-resources&maven.extension=zip' \
				| jq -r --arg MAJOR $$GENERAL_RESOURCES_MAJOR_VERSION ' \
					.items \
					| map(select(.version | startswith($$MAJOR))) \
					| sort_by(.version | split(".") | map(tonumber)) \
					| last.version' \
				)}"; \
			if [ -z "$$artifact_version" ]; then \
				echo "No artifact found with major version $$GENERAL_RESOURCES_MAJOR_VERSION."; \
				exit 1; \
			fi; \
			echo "Downloading general resources artifact version: $$artifact_version ..."; \
			curl -k -L --retry 5 --silent \
				"https://nexus-tools.swacorp.com/service/rest/v1/search/assets/download?repository=releases&group=com.swacorp.ccplat.swa-common.devplat.ccp-next&name=ccp-next-general-resources&maven.extension=zip&version=$${artifact_version}" \
				--output ./.general-resources/general-resources.zip; \
			echo "$$artifact_version" > .general-resources/version.txt; \
		else \
			echo "Downloading general resources artifact: $${GENERAL_RESOURCES_URL} ..."; \
			curl -k -L --retry 5 --silent "$${GENERAL_RESOURCES_URL}" --output ./.general-resources/general-resources.zip; \
			echo "$${GENERAL_RESOURCES_URL}" > .general-resources/version.txt; \
		fi; \
		unzip -q -o ./.general-resources/general-resources.zip -d ./.general-resources; \
	fi

	@cp ./.general-resources/resources/module_setup.sh ./; \
		bash module_setup.sh; \
		rm module_setup.sh

	@artifact_version=$$(cat .general-resources/version.txt); \
		echo "Using general resources artifact: $$artifact_version."; \
		$(MAKE) --no-print-directory -f .general-resources.mk setup-local

	@if [ -z "$$GENERAL_RESOURCES_CACHING_ENABLED" ] || [ "$$GENERAL_RESOURCES_CACHING_ENABLED" != "true" ]; then \
		rm -rf .general-resources; \
	fi

# does not try to forward in pipelines or if the target is in the current Makefile.
# this is **very** delicate and should be modified with caution.
%: FORCE
	@if [[ ! -f .general-resources.mk ]]; then \
		echo ".general-resources.mk not found; run 'make setup' to create it."; \
	else \
		ALL_TARGETS="$$(grep '^[^#[:space:]].*:' Makefile)"; \
		if [[ "$@" != "Makefile" && "$${ALL_TARGETS}" != *"$@:"* ]]; then \
			$(MAKE) --no-print-directory -f .general-resources.mk $@; \
		fi; \
	fi

# alternative to using .PHONY; useful for dynamically generated targets
FORCE: ;
