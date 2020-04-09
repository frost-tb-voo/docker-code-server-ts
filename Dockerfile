FROM node as extension
MAINTAINER Novs Yama

ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/frost-tb-voo/docker-code-server-ts"

WORKDIR /prettier
RUN git clone https://github.com/prettier/prettier-vscode.git \
 && cd ./prettier-vscode \
 && npm install --silent \
 && npm audit fix --force \
 && npm cache clean --force \
 && rm -rf node_modules package-lock.json \
 && npm install --silent \
 && npm audit fix --force \
 && ./node_modules/vsce/out/vsce package \
 && npm cache clean --force \
 && rm -rf ~/.npm \
 && mv *.vsix ../ \
 && cd ../ \
 && rm -rf /prettier/prettier-vscode

FROM codercom/code-server
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
ADD settings.json /home/coder/.local/share/code-server/Machine
ADD settings.json /home/coder/project/.vscode/settings.json
COPY --from=extension /prettier/*.vsix /home/coder/
RUN chown -hR coder /home/coder

USER coder
WORKDIR /home/coder/project
RUN code-server --install-extension /home/coder/*.vsix

