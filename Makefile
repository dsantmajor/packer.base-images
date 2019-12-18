
WORKING_DIR := $(shell pwd)
PACKER_BOX_DIR := $(WORKING_DIR)/packer_boxes
APPLICATION_NAME := openvpn-server
BOX_TYPE := coreos-gce-stable
# BOX_TYPE := test
PACKER_FILE := ${PACKER_BOX_DIR}/$(BOX_TYPE)/$(APPLICATION_NAME)
.DEFAULT_GOAL := help

.PHONY: build
build: ## Build a packer image for GCP Compute Engine
	@packer build $(PACKER_FILE).json

.PHONY: _build_debug
_build_debug: ## Build a packer image for GCP Compute Engine
	@packer build -debug $(PACKER_FILE).json

.PHONY: validate
validate: ## Validates a packer template
	@packer validate $(PACKER_FILE).json



export ENV_PATH ?= local
export CONFIG ?= local
export CONFIG_ENV ?= env/$(ENV_PATH)/$(CONFIG).env

ENVY_MK := .envy.mk
$(eval $(shell ./vendor_utils/envy.sh/envy.sh "$(CONFIG_ENV)" make "$(ENVY_MK)" && echo "include $(ENVY_MK)" || echo "\$$(error Problem running envy)"))



.PHONY: clean
clean: ## Delete the values in .envy.mk
	-rm -f $(ENVY_MK)

# A help target including self-documenting targets (see the awk statement)
define HELP_TEXT
Usage: make [TARGET]... [MAKEVAR1=SOMETHING]...

Available targets:
endef
export HELP_TEXT
help: ## This help target
	@cat .banner
	@echo " "
	@echo " "
	@echo "Clone this repo as a template"
	@echo " "
	@echo " "
	@echo "$$HELP_TEXT"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / \
		{printf "\033[36m%-30s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)

