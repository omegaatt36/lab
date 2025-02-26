ARG BASE_IMAGE=base-dev

FROM ${BASE_IMAGE}

ARG USERNAME=raiven_kao

USER root

# Install nodejs and npm.
RUN zypper refresh && zypper --non-interactive install \
    python3 python3-pip uv

USER ${USERNAME}
