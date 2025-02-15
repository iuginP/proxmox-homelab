nioorg-traefik role
=========

[![Build Status](https://github.com/nioorg/role-traefik/actions/workflows/build.yml/badge.svg?branch=master)](https://github.com/nioorg/role-traefik/actions/workflows/build.yml)

This Ansible role installs and configures traefik on the machine. The main features of this roles are the following:

* Support any number of entrypoint
* Force redirect to other port by default
* Support auto-generated TLS certificates
* Support [User defined](https://doc.traefik.io/traefik/https/tls/#user-defined) TLS certificates
* Support [Let's Encrypt Automatic HTTPS](https://docs.traefik.io/https/acme/#lets-encrypt) with HTTP challenge
* Support User defined client certificates for mTLS enforcement
* Support dynamic configuration with Docker provider
* Support dynamic configuration with file provider

Requirements
------------

To execute this role you need the following system packages:

* docker
* docker-compose
* pip

And the following pip packages, to use Docker from the Ansible role:

* docker
* docker-compose

Role Variables
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

Dependencies
------------

This role doesn't have any direct dependency.

Despite that, it is recomended to use the following roles before running this one:
* [common](https://github.com/nioorg/role-common) - to perform the basic configuration of the server
* [docker](https://github.com/geerlingguy/ansible-role-docker) - to install docker and docker-compose
* [pip](https://github.com/geerlingguy/ansible-role-pip.git) - to install pip and the docker packages

Example Playbook
----------------

Here is an example playbook using the default variables:

```yaml
- hosts: all
  roles:
    - traefik
```

Here is an example playbook where we restrict the ip addresses the server listens on, for security reasons:

```yaml
- hosts: all
  roles:
    - role: traefik
      vars:
        traefik_listening:
          - 192.168.0.0/16
```

In the following example we use the roles recomended in the [Dependencies](https://github.com/nioorg/role-traefik#dependencies) section to completely setup the server:

```yaml
- hosts: all
  roles:
    - role: common
    - role: pip
      become: yes
      vars:
        pip_install_packages:
          - name: docker
          - name: docker-compose
    - role: docker
      become: yes
    - role: traefik
```

License
-------

See LICENSE

Author Information
------------------

https://github.com/iuginP/
