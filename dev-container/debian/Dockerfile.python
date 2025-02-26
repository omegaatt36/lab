ARG BASE_IMAGE=base-dev

FROM ${BASE_IMAGE}

ARG USERNAME=raiven_kao

USER root

# Install nodejs and npm.
RUN apt update && apt install -y \
    python3 python3-pip

RUN curl -LsSf https://astral.sh/uv/install.sh | sh

USER ${USERNAME}
