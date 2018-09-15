LANG  := C
CYAN  := \033[36m
GREEN := \033[32m
RESET := \033[0m
IMAGE := lambdalisue/neovim-ci
TAG   := latest

ifeq (${TAG},latest)
    OPTIONS :=
else
    OPTIONS := --branch ${TAG}
endif

# http://postd.cc/auto-documented-makefile/
.DEFAULT_GOAL := help
.PHONY: help
help: ## Show this help
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "${CYAN}%-30s${RESET} %s\n", $$1, $$2}'

.PHONY: image

image: ## Build a docker image
	@echo "${GREEN}Building a docker image (${IMAGE}:${TAG}) of Neovim ${BRANCH}${RESET}"
	@docker build --build-arg OPTIONS="${OPTIONS}" -t ${IMAGE}:${TAG} .

.PHONY: pull
pull: ## Pull a docker image
	@echo "${GREEN}Pulling a docker image (${IMAGE}:${TAG})${RESET}"
	@docker pull ${IMAGE}:${TAG}

.PHONY: push
push: ## Push a docker image
	@echo "${GREEN}Pushing a docker image (${IMAGE}:${TAG})${RESET}"
	@docker push ${IMAGE}:${TAG}

.PHONY: all
all: ## All
	@make image push
	@make TAG=v0.2.0 image push
	@make TAG=v0.2.1 image push
	@make TAG=v0.2.2 image push
	@make TAG=v0.3.0 image push
	@make TAG=v0.3.1 image push
