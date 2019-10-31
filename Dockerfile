FROM node as extension
MAINTAINER Novs Yama

ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/frost-tb-voo/docker-code-server-ts"

WORKDIR /prettier
RUN apt-get -qq update \
 && apt-get -qq -y install curl zip unzip \
 && curl -L -o prettier-vscode-1.7.0.vsix https://github.com/prettier/prettier-vscode/releases/download/v1.7.0/prettier-vscode-1.7.0.vsix \
 && unzip -q prettier-vscode-1.7.0.vsix \
 && rm prettier-vscode-1.7.0.vsix \
 && cd /prettier/extension \
 && npm install --silent \
 && npm audit fix --force \
 && npm cache clean --force \
 && rm -rf node_modules package-lock.json \
 && npm install --silent \
 && npm audit fix --force \
 && npm cache clean --force \
 && rm -rf ~/.npm \
 && cd /prettier \
 && zip -q -r prettier-vscode-1.7.0.vsix .

FROM codercom/code-server:v2
MAINTAINER Novs Yama

ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/frost-tb-voo/docker-code-server-ts"

USER root
WORKDIR /prettier
RUN apt-get -qq update \
 && apt-get -qq -y install npm \
 && apt-get -q -y autoclean \
 && apt-get -q -y autoremove \
 && rm -rf /var/lib/apt/lists \
 && npm install -g n --silent \
 && npm cache clean --force -g \
 && rm -rf ~/.npm \
 && n stable
RUN npm install -g typescript ts-node --silent \
 && npm cache clean --force -g \
 && rm -rf ~/.npm

ADD settings.json /home/coder/.local/share/code-server/User/settings.json
RUN chown -hR coder /home/coder

USER coder
WORKDIR /home/coder/project
COPY --from=extension /prettier/prettier-vscode-1.7.0.vsix /home/coder/
RUN code-server --install-extension /home/coder/prettier-vscode-1.7.0.vsix

