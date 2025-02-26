ARG BASE_IMAGE=base-dev

FROM ${BASE_IMAGE}

ARG USERNAME=raiven_kao

ENV NODE_VERSION=22

USER root

RUN <<EOF
curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt-get install -y nodejs
EOF

USER ${USERNAME}

RUN mkdir ${HOME}/.npm-global && npm config set prefix ${HOME}/.npm-global
