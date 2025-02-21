build:
	docker build -t base-dev -f Dockerfile.tumbleweed.base --build-arg USERNAME=$(shell whoami) .
	docker build -t python-dev --build-arg BASE_IMAGE=base-dev --build-arg USERNAME=$(shell whoami) -f python-tumbleweed/Dockerfile .
	docker build -t node-dev --build-arg BASE_IMAGE=base-dev --build-arg USERNAME=$(shell whoami) -f node-tumbleweed/Dockerfile .
