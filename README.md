# DTR Policy Container
This container enforces all repositories in a DTR to have visibility set to private and scanOnPush set to true.

## Getting started

### Clone the git repo

```git clone https://github.com/pvdbleek/dtr-policy```

### Adjust the Dockerfile
The default cron schedule in the Dockerfile is every 5 minutes.
You might want to adjust that to your preferred time.

### Build & push the image

```docker build -t <namespace>/<repository> .```

```docker push <namespace>/<repository>```

### Deploy DTR credentials to Docker Swarm secrets


```echo <your_dtr_password> | docker secret create dtr_passwd -```

### Deploy dtr-policy as a swarm service

```
docker service create --name dtr-policy -e DTR_URL="https://<your_dtr_url_goes_here>" -e DTR_USER="<a_dtr_admin_username>" --secret dtr_passwd <namespace>/<repository>
```


