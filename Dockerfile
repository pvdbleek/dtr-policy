FROM alpine:latest

MAINTAINER patrick.bleek@docker.com

RUN apk add --update curl && \
    rm -rf /var/cache/apk/*

RUN apk add --no-cache jq && \
    rm -rf /var/cache/apk/*

COPY dtr-policy.sh /root/

RUN echo "*/5 * * * *	/root/dtr-policy.sh" >>/etc/crontabs/root

CMD ["/usr/sbin/crond","-c","/etc/crontabs","-f"]
