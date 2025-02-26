ROOT_DIR := $(abspath ./)
include $(ROOT_DIR)/variables.mk

build-tumbleweed:
	docker build -t $(IMAGE_REPOSITORY)/base-dev -f tumbleweed/Dockerfile.base --build-arg USERNAME=$(shell whoami) .
	docker build -t $(IMAGE_REPOSITORY)/python-dev --build-arg BASE_IMAGE=$(IMAGE_REPOSITORY)/base-dev --build-arg USERNAME=$(shell whoami) -f tumbleweed/Dockerfile.python .
	docker build -t $(IMAGE_REPOSITORY)/node-dev --build-arg BASE_IMAGE=$(IMAGE_REPOSITORY)/base-dev --build-arg USERNAME=$(shell whoami) -f tumbleweed/Dockerfile.node .

build-debian:
	docker build -t $(IMAGE_REPOSITORY)/base-dev -f debian/Dockerfile.base --build-arg USERNAME=$(shell whoami) .
	docker build -t $(IMAGE_REPOSITORY)/python-dev --build-arg BASE_IMAGE=$(IMAGE_REPOSITORY)/base-dev --build-arg USERNAME=$(shell whoami) -f debian/Dockerfile.python .
	docker build -t $(IMAGE_REPOSITORY)/node-dev --build-arg BASE_IMAGE=$(IMAGE_REPOSITORY)/base-dev --build-arg USERNAME=$(shell whoami) -f debian/Dockerfile.node .
	docker build -t $(IMAGE_REPOSITORY)/java-dev --build-arg BASE_IMAGE=$(IMAGE_REPOSITORY)/base-dev --build-arg USERNAME=$(shell whoami) -f debian/Dockerfile.java .

bin:
	go build -o dev-container

install:
	mv dev-container /usr/local/bin/
