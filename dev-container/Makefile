build-tumbleweed:
	docker build -t base-dev -f Dockerfile.tumbleweed.base --build-arg USERNAME=$(shell whoami) .
	docker build -t python-dev --build-arg BASE_IMAGE=base-dev --build-arg USERNAME=$(shell whoami) -f python-tumbleweed/Dockerfile .
	docker build -t node-dev --build-arg BASE_IMAGE=base-dev --build-arg USERNAME=$(shell whoami) -f node-tumbleweed/Dockerfile .

build-debian:
	docker build -t base-dev -f Dockerfile.debian.base --build-arg USERNAME=$(shell whoami) .
	docker build -t python-dev --build-arg BASE_IMAGE=base-dev --build-arg USERNAME=$(shell whoami) -f python-debian/Dockerfile .
	docker build -t node-dev --build-arg BASE_IMAGE=base-dev --build-arg USERNAME=$(shell whoami) -f node-debian/Dockerfile .
