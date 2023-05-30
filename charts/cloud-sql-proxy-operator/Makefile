SHELL := /bin/bash

.PHONY = help
.DEFAULT_GOAL := help

template: ## generate the helm template
	@helm repo add kjvellajr https://kjvellajr.github.io/helm-charts 1>&2
	@helm dependency build 1>&2
	@helm template \
		--name-template cloud-sql-proxy-operator \
		--namespace cloud-sql-proxy-operator \
		--values values.yaml \
		.
download: ## download resources from repo for reference
	curl https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy-operator/v1.0.0/cloud-sql-proxy-operator.yaml > cloud-sql-proxy-operator.yaml

help: 
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
