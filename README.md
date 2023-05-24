# Protoconf Webhook Docker

## Install and run consul on your mac

```shell
brew install hashicorp/tap/consul
brew services start consul
```

## Generate github secret

```shell
ruby -rsecurerandom -e 'puts SecureRandom.hex(20)'
```

## Run in docker

```shell
docker run -p 9000:9000 \
    -e STORE=consul \
    -e STORE_ADDRESS=host.docker.internal:8500 \
    -e GITHUB_WEBHOOK_SECRET=<> \
    -e PREFIX=prod/ \
    -e GIT_USER=<your github user> \
    -e GIT_PASSWORD=<your github token> \
    ghcr.io/protoconf/protoconf-webhook:v0
```
