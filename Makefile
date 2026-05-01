SNAME ?= maddy
RNAME ?= elswork/$(SNAME)
VER ?= `cat VERSION`
BASENAME ?= alpine:3.21.2
PARAM ?= someparameter
TARGET_PLATFORM ?= linux/amd64,linux/arm64
NO_CACHE ?= 
# NO_CACHE ?= --no-cache
# linux/amd64,linux/arm64,linux/ppc64le,linux/s390x,linux/386,linux/arm/v7,linux/arm/v6

# HELP
# This will output the help for each task

.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# DOCKER TASKS

# Build image

debug: ## Debug the container
	docker build -t $(RNAME):debug \
	--build-arg BASEIMAGE=$(BASENAME) \
	--build-arg VERSION=$(VER) .

build: ## Build the container
	mkdir -p builds
	docker build $(NO_CACHE) -t $(RNAME):$(VER) -t $(RNAME):latest \
	--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	--build-arg VCS_REF=`git rev-parse --short HEAD` \
	--build-arg BASEIMAGE=$(BASENAME) \
	--build-arg VERSION=$(VER) \
	. > builds/$(VER)_`date +"%Y%m%d_%H%M%S"`.txt

bootstrap: ## Start multicompiler
	docker buildx inspect --bootstrap

debugx: ## Buildx in Debug mode
	docker buildx build \
	--platform ${TARGET_PLATFORM} \
	-t $(RNAME):debug --pull \
	--build-arg BASEIMAGE=$(BASENAME) \
	--build-arg VERSION=$(VER) .

buildx: ## Buildx the container
	docker buildx build $(NO_CACHE) \
	--platform ${TARGET_PLATFORM} \
	-t $(RNAME):$(VER) -t $(RNAME):latest --pull --push \
	-t ghcr.io/$(RNAME):$(VER) -t ghcr.io/$(RNAME):latest \
	--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	--build-arg VCS_REF=`git rev-parse --short HEAD` \
	--build-arg BASEIMAGE=$(BASENAME) \
	--build-arg VERSION=$(VER) .

# Operations

console: ## Start console in container
	docker run -it --rm --entrypoint "/bin/ash" -v $(PWD)/maddy_data:/data $(RNAME):$(VER)

debugconsole: ## Start a debug console in container
	docker run -it --rm --entrypoint "/bin/ash" -v $(PWD)/maddy_data:/data $(RNAME):debug

setup: ## Initialize directories and self-signed certs
	mkdir -p maddy_data/tls
	openssl req -x509 -newkey rsa:4096 -keyout maddy_data/tls/privkey.pem -out maddy_data/tls/fullchain.pem -days 365 -nodes -subj "/CN=palanca.dl4.eu"
	cp maddy.conf maddy_data/maddy.conf

start: ## Start the container
	docker run -d --name $(SNAME) \
		-v $(PWD)/maddy_data:/data \
		-p 25:25 -p 143:143 -p 465:465 -p 587:587 -p 993:993 \
		$(RNAME):$(VER) $(PARAM)

stop: ## Stop the container
	docker stop $(SNAME)
	docker rm $(SNAME)

creds: ## Create a new user (usage: make creds USER=name@domain)
	docker exec -it $(SNAME) maddy creds create $(USER)
