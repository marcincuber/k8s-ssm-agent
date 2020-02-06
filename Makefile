AWS_IAM_AUTHENTICATOR_VERSION=$$(curl -s "https://api.github.com/repos/kubernetes-sigs/aws-iam-authenticator/releases/latest" | jq -r .tag_name | grep -Ev "beta|alpha|rc" | sed 's|v||')
KUBECTL_VERSION=$$(curl -s "https://storage.googleapis.com/kubernetes-release/release/stable.txt" | sed 's|v||')

NAME ?= "k8s-ssm-agent"
LOGIN_CMD := "docker login $(REGISTRY)"
REGISTRY ?= "umotif"

build_version: ## docker build image
	docker build -t $(REGISTRY)/$(NAME):$(KUBECTL_VERSION) --build-arg AWS_IAM_AUTHENTICATOR_VERSION=$(AWS_IAM_AUTHENTICATOR_VERSION) --build-arg KUBECTL_VERSION=$(KUBECTL_VERSION) .

save: ## docker save image
	docker save $(REGISTRY)/$(NAME):$(KUBECTL_VERSION) -o $(NAME)_$(VERSION).tar

load: ## docker load image
	docker load -i $(NAME)_$(VERSION).tar

push_version: ## docker push image
	docker push $(REGISTRY)/$(NAME):$(KUBECTL_VERSION)

image_exists: ## check if docker image exists
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest inspect $(REGISTRY)/$(NAME):$(KUBECTL_VERSION)

.PHONY: help
help:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
