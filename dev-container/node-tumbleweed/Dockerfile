ARG BASE_IMAGE=base-dev

FROM ${BASE_IMAGE}

ARG USERNAME=raiven_kao

ENV NODE_VERSION=22

USER root

# Install nodejs and npm.
RUN zypper refresh && zypper --non-interactive install \
    nodejs${NODE_VERSION} npm${NODE_VERSION}

USER ${USERNAME}

RUN mkdir ${HOME}/.npm-global && npm config set prefix ${HOME}/.npm-global
