LANG  := C
CYAN  := \033[36m
GREEN := \033[32m
RESET := \033[0m
IMAGE := lambdalisue/neovim-ci
TAG   := latest

ifeq (${TAG},latest)
    NEOVIM_VERSION := stable
else
    NEOVIM_VERSION := ${TAG}
endif


# http://postd.cc/auto-documented-makefile/
.DEFAULT_GOAL := help
.PHONY: help
help: ## Show this help
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "${CYAN}%-30s${RESET} %s\n", $$1, $$2}'

.PHONY: image
image: ## Build a docker image
	@docker build \
	    -t ${IMAGE}:${TAG} \
	    --build-arg NEOVIM_VERSION="${NEOVIM_VERSION}" \
	    .

.PHONY: run
run: ## Build a docker image
	@docker run  --rm -it ${IMAGE}:${TAG}

.PHONY: pull
pull: ## Pull a docker image
	@docker pull ${IMAGE}:${TAG}

.PHONY: push
push: ## Push a docker image
	@docker push ${IMAGE}:${TAG}

.PHONY: compensate
compensate: ## Compensate images in dockerhub
	@./scripts/list_missing_tags.sh | xargs -I{} -L1 make TAG={} image push
