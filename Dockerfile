#FROM codercom/code-server:1.939
FROM codercom/code-server:latest
MAINTAINER Novs Yama

ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/frost-tb-voo/docker-code-server-ts"

USER root
WORKDIR /prettier
RUN apt-get -qq update \
 && apt-get -q -y install npm \
 && apt-get -q -y autoclean \
 && apt-get -q -y autoremove \
 && rm -rf /var/lib/apt/lists \
 && npm install -g n --silent \
 && n stable
RUN npm install -g yarn typescript --silent
RUN apt-get -qq update \
 && apt-get -q -y install curl zip unzip \
 && curl -L -o prettier-vscode-1.7.0.vsix https://github.com/prettier/prettier-vscode/releases/download/v1.7.0/prettier-vscode-1.7.0.vsix \
 && unzip -q prettier-vscode-1.7.0.vsix \
 && rm prettier-vscode-1.7.0.vsix \
 && cd /prettier/extension \
 && npm install \
 && npm audit fix --force \
 && rm -r node_modules package-lock.json \
 && yarn install \
 && cd /prettier \
 && zip -q -r prettier-vscode-1.7.0.vsix . \
 && rm -r /prettier/extension \
 && apt-get -q -y purge curl zip unzip \
 && apt-get -q -y autoclean \
 && apt-get -q -y autoremove \
 && rm -rf /var/lib/apt/lists

USER coder
RUN code-server --install-extension /prettier/prettier-vscode-1.7.0.vsix

USER root
ADD settings.json /home/coder/.local/share/code-server/User/settings.json
RUN cd / \
 && rm -r /prettier \
 && chown -hR coder /home/coder

USER coder
WORKDIR /home/coder/project


