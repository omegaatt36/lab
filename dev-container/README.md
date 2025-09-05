# Development Container Setup

This repository contains Dockerfiles for creating isolated development environments. The primary goal is to mitigate potential malware attacks and manage specific development tool versions (e.g., Node.js versions 14, 16, 22).

## Usage

These Docker images are designed to be used within your project directories.  The following examples demonstrate how to run the `python-dev` and `node-dev` images.

### Python

```bash
docker run --rm -it \
  -w /home/$(whoami)/app \
  --hostname dev-container-python \
  -v $(pwd):/home/$(whoami)/app \
  -v ${HOME}/.zsh_other_env:/home/$(whoami)/.zsh_other_env \
  -v ${HOME}/.wakatime.cfg:/home/$(whoami)/.wakatime.cfg \
  --name dev-python-$(basename $(pwd)) \
  omegaatt36/python-dev:latest
```

### Node.js

```bash
docker run --rm -it \
  -w /home/$(whoami)/app \
  --hostname dev-container-node \
  -v $(pwd):/home/$(whoami)/app \
  -v ${HOME}/.zsh_other_env:/home/$(whoami)/.zsh_other_env \
  -v ${HOME}/.npmrc:/home/$(whoami)/.npmrc \
  -v ${HOME}/.wakatime.cfg:/home/$(whoami)/.wakatime.cfg \
  --name dev-node-$(basename $(pwd)) \
  omegaatt36/node-dev:latest
```

## Java

```bash
docker run --rm -it \
  -w /home/$(whoami)/app \
  --hostname dev-container-java \
  -v $(pwd):/home/$(whoami)/app \
  -v ${HOME}/.zsh_other_env:/home/$(whoami)/.zsh_other_env \
  -v ${HOME}/.wakatime.cfg:/home/$(whoami)/.wakatime.cfg \
  --name dev-java-$(basename $(pwd)) \
  omegaatt36/java-dev:latest
```

## Explanation of Docker Run Arguments:

*   `--rm`: Automatically removes the container when it exits.
*   `-it`:  Allocates a pseudo-TTY and keeps STDIN open, allowing interactive sessions.
*   `-w /home/$(whoami)/app`: Sets the working directory inside the container.
*   `--hostname dev-container-<lang>`: Sets the hostname of the container.
*   `-v $(pwd):/home/$(whoami)/app`: Mounts the current working directory on the host to `/home/$(whoami)/app` inside the container.  This allows you to work on your project files directly.
*   `-v ${HOME}/.zsh_other_env:/home/$(whoami)/.zsh_other_env`: Mounts the `.zsh_other_env` file from your host to the container. Useful for environment variables.
*   `-v ${HOME}/.npmrc:/home/$(whoami)/.npmrc`: Mounts your npm configuration.
*   `-v ${HOME}/.wakatime.cfg:/home/$(whoami)/.wakatime.cfg`: Mounts your Wakatime configuration.
*   `--name dev-<lang>-$(basename $(pwd))`: Assigns a name to the container, incorporating the project directory name.
*   `<image_name>:latest`: Specifies the Docker image to use.

## Makefile

The provided `Makefile` simplifies building the Docker images. Use the following commands:

*   `make build`: Builds all the Docker images (base, python, node).

Then see the result:

```sh
❯ docker image ls -a
REPOSITORY                         TAG                    IMAGE ID       CREATED        SIZE
omegaatt36/dev-container          noble-claude-code      8a7b9c2d3e4f   2 hours ago    742MB
omegaatt36/dev-container          noble-node             3d5746d1b9f5   17 hours ago   686MB
omegaatt36/dev-container          noble                  6e29436b84c6   17 hours ago   553MB
omegaatt36/dev-container          noble-python           6e29436b84c6   17 hours ago   553MB
```

## Customization

You can customize the Dockerfiles to suit your specific needs. For example, you can add more packages or change the base image.
