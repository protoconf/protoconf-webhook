FROM ghcr.io/protoconf/protoconf:v0.1.7 AS protoconf
FROM almir/webhook:2.8.0 AS webhook

FROM ubuntu:22.04
RUN apt-get update && apt-get install -y bash git musl jq make ssh curl  && rm -rvf /var/lib/apt/lists/*
COPY --from=webhook /usr/local/bin/webhook /usr/local/bin/webhook
COPY --from=protoconf /protoconf /usr/local/bin/protoconf
COPY webhook.json.tmpl /etc/webhook/webhook.json.tmpl
COPY protoconf-insert-script.sh /hooks/protoconf-insert-script.sh
RUN chmod +x /hooks/protoconf-insert-script.sh
RUN chmod +x /usr/local/bin/protoconf
RUN git config --global credential.helper '!f() { sleep 1; echo "username=${GIT_USER}"; echo "password=${GIT_PASSWORD}"; }; f'
ENTRYPOINT ["/usr/local/bin/webhook",  "-template", "-hooks", "/etc/webhook/webhook.json.tmpl", "-verbose" ]