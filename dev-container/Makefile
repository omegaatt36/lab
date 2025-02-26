ROOT_DIR := $(abspath ./)
include $(ROOT_DIR)/variables.mk

build-tumbleweed:
	docker build -t $(IMAGE_REPOSITORY)/base-dev -f Dockerfile.tumbleweed.base --build-arg USERNAME=$(shell whoami) .
	docker build -t $(IMAGE_REPOSITORY)/python-dev --build-arg BASE_IMAGE=$(IMAGE_REPOSITORY)/base-dev --build-arg USERNAME=$(shell whoami) -f python-tumbleweed/Dockerfile .
	docker build -t $(IMAGE_REPOSITORY)/node-dev --build-arg BASE_IMAGE=$(IMAGE_REPOSITORY)/base-dev --build-arg USERNAME=$(shell whoami) -f node-tumbleweed/Dockerfile .

build-debian:
	docker build -t $(IMAGE_REPOSITORY)/base-dev -f Dockerfile.debian.base --build-arg USERNAME=$(shell whoami) .
	docker build -t $(IMAGE_REPOSITORY)/python-dev --build-arg BASE_IMAGE=$(IMAGE_REPOSITORY)/base-dev --build-arg USERNAME=$(shell whoami) -f python-debian/Dockerfile .
	docker build -t $(IMAGE_REPOSITORY)/node-dev --build-arg BASE_IMAGE=$(IMAGE_REPOSITORY)/base-dev --build-arg USERNAME=$(shell whoami) -f node-debian/Dockerfile .
	docker build -t $(IMAGE_REPOSITORY)/java-dev --build-arg BASE_IMAGE=$(IMAGE_REPOSITORY)/base-dev --build-arg USERNAME=$(shell whoami) -f java-debian/Dockerfile .
