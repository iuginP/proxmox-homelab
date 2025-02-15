Traefik app
=========

This app installs and configures traefik on the machine. The main features of this app are the following:

* Support any number of entrypoint
* Force redirect to other port by default
* Support auto-generated TLS certificates
* Support [User defined](https://doc.traefik.io/traefik/https/tls/#user-defined) TLS certificates
* Support [Let's Encrypt Automatic HTTPS](https://docs.traefik.io/https/acme/#lets-encrypt) with HTTP challenge
* Support User defined client certificates for mTLS enforcement
* Support dynamic configuration with Docker provider
* Support dynamic configuration with file provider

Ansible Variables
--------------

All varibales are optional.

The following is the list of the available variables and its default values:

```yaml
traefik_path: "/opt/traefik"
# List of subnets the server will be listening on.
# By default it listens for connections from everywhere.
traefik_listening:
  - 0.0.0.0/0

traefik:
traefik_image: "traefik:latest"
traefik_log_level: INFO
traefik_entrypoints:
  - name: web
    port: 80
    redirect: websecure
  - name: websecure
    port: 443
traefik_dashboard: true
  # User defined certificates
  # certificates:
  #   - cert: /path/to/domain.cert
  #     key: /path/to/domain.key
  # client_auth:
  #   - name: requiremtls
  #     ca_files:
  #       - tests/clientca1.crt
  #       - tests/clientca2.crt
  #     auth_type: RequireAndVerifyClientCert
traefik_certificates_resolvers: []
  # # Let's Encrypt certificate resolver
  # letsencrypt:
  #   email: your-email@example.com
  #   ca_server: https://acme-v02.api.letsencrypt.org/directory
  #   http_challenge:
  #     entrypoint: web
  #   # dns_challenge:
  #   #   provider: TODO-cloudflare
  #   #   api_keys:
  #   #     - name: CF_DNS_API_TOKEN
  #   #       value: TODO-cloudflare-token
traefik_hostname: "traefik.{{ inventory_hostname }}"
```
