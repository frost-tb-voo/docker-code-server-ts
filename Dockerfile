#FROM codercom/code-server:1.939
FROM codercom/code-server:latest
MAINTAINER Novs Yama

ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/frost-tb-voo/docker-code-server-ts"

USER root
RUN apt-get update \
 && apt-get -y install curl zip unzip npm \
 && apt-get -y autoclean \
 && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists
RUN npm install -g n \
 && n stable
RUN npm install -g yarn typescript
WORKDIR /prettier
RUN curl -L -o prettier-vscode-1.7.0.vsix https://github.com/prettier/prettier-vscode/releases/download/v1.7.0/prettier-vscode-1.7.0.vsix \
 && unzip -q prettier-vscode-1.7.0.vsix \
 && rm prettier-vscode-1.7.0.vsix
WORKDIR /prettier/extension
RUN npm install \
 && npm audit fix --force \
 && rm -r node_modules package-lock.json \
 && yarn install
WORKDIR /prettier
RUN zip -q -r prettier-vscode-1.7.0.vsix .

USER coder
RUN code-server --install-extension prettier-vscode-1.7.0.vsix

USER root
ADD settings.json /home/coder/.local/share/code-server/User/settings.json
RUN cd / \
 && rm -r /prettier \
 && chown -hR coder /home/coder

USER coder
WORKDIR /home/coder/project


