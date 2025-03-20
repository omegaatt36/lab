ARG BASE_IMAGE=base-dev

FROM ${BASE_IMAGE}

ARG USERNAME=coder

USER root

RUN apt update && apt install -y maven openjdk-17-jdk

USER ${USERNAME}
