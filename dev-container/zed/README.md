```sh
docker run -d --name zed-remote \
  --restart unless-stopped \
  -p 2222:22 \
  -v $(pwd):/home/$(whoami)/work \
  -v ~/.ssh/known_hosts:/home/$(whoami)/.ssh/known_hosts:ro \
  zed-remote:ubuntu
```

~/.ssh/config
```sh
Host zed-server
    HostName localhost
    Port 2222
    IdentityFile ~/.ssh/id_ed25519.zed
    User {HOST_USER}
```
