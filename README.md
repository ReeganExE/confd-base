# Confd Base Image | [Docker Hub](https://hub.docker.com/r/reeganexe/confd-base/)

Base Docker image that can be used for generating file config from environment/consul/...

This will helpful when you use a 3rd party application and it requires configuration from file. It might use as a [sidekick service](https://rancher.com/docs/rancher/v1.6/en/cattle/adding-services/#sidekick-services) in Rancher.

## Example Usage | [Full Source](https://github.com/ReeganExE/confd-example)

Create `conf.d` and `templates` directories and add files.

### Structure
```
templates/
conf.d/
Dockerfile
entrypoint.sh
```

### `Dockerfile`

```Dockerfile
FROM reeganexe/confd-base:0.16

COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
```

### `conf.d/my-app.yml.toml`

```toml
[template]
src  = "my-app.yml.tmpl"
dest = "/etc/my-app.yml"
keys = [
 "/first/name",
 "/db/schema"
]
```
### `templates/my-app.yml.tmpl`

```yml
spring:
  apps:
    - name: {{getv "/first/name"}}
    - db: "jdbc:mysql://localhost/{{getv "/db/schema"}}?useSSL=true&requireSSL=true"
```

### `entrypoint.sh`

```sh
#!/bin/sh

# Generate config from template
confd -onetime -backend env

# Print output
echo ---------------------------
cat /etc/my-app.yml
```

### Run

```sh
docker build -t confd-example .
docker run --rm -it -e FIRST_NAME=beneficiary-app -e DB_SCHEMA=beneficiary confd-example
```

The output would look like this:

```
2018-08-26T06:33:06Z dac19b291159 confd[7]: INFO Backend set to env
2018-08-26T06:33:06Z dac19b291159 confd[7]: INFO Starting confd
2018-08-26T06:33:06Z dac19b291159 confd[7]: INFO Backend source(s) set to
2018-08-26T06:33:06Z dac19b291159 confd[7]: INFO Target config /etc/my-app.yml out of sync
2018-08-26T06:33:06Z dac19b291159 confd[7]: INFO Target config /etc/my-app.yml has been updated
---------------------------
spring:
  apps:
    - name: beneficiary-app
    - db: "jdbc:mysql://localhost/beneficiary?useSSL=true&requireSSL=true"
```

Example repo: https://github.com/ReeganExE/confd-example
