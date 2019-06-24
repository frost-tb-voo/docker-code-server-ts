# docker-code-server-ts
![](https://img.shields.io/travis/frost-tb-voo/docker-code-server-ts/master.svg?style=flat-square)
![GitHub stars](https://img.shields.io/github/stars/frost-tb-voo/docker-code-server-ts.svg?style=flat-square)
![GitHub license](https://img.shields.io/github/license/frost-tb-voo/docker-code-server-ts.svg?style=flat-square)
![Docker pulls](https://img.shields.io/docker/pulls/novsyama/code-server-ts.svg?style=flat-square)
![Docker image-size](https://img.shields.io/microbadger/image-size/novsyama/code-server-ts.svg?style=flat-square)
![Docker layers](https://img.shields.io/microbadger/layers/novsyama/code-server-ts.svg?style=flat-square)

An unofficial extended VSCode [code-server](https://github.com/cdr/code-server) image for latest typescript with prettier.
See [novsyama/code-server-ts](https://hub.docker.com/r/novsyama/code-server-ts/)

## How

```bash
ABS_DIR=<workspace absolute path>

sudo docker pull novsyama/code-server-ts
sudo docker run --name=vscode --net=host -d \
 -v "${ABS_DIR}:/home/coder/project" \
 -w /home/coder/project \
 novsyama/code-server-ts \
 code-server \
 --allow-http --no-auth
```

And open http://localhost:8443 with your favorites browser.
For detail options, see [code-server](https://github.com/cdr/code-server).

### Prettier keyboard shortcuts
`Ctrl+Shift+I` or `Ctrl+K`.
Please confirm File > Preferences menu of your environment.

### Pathes of vscode code-server
If you want to preserve the settings and extensions, please mount following pathes with `-v` option of `docker run` command.

- Home : /home/coder
- Extension path : ~/.local/share/code-server/extensions
- Settings path : ~/.local/share/code-server/User/settings.json

