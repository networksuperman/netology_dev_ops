#!/usr/bin/env bash
docker-compose up -d
ansible-playbook site.yml -i inventory/prod.yml --vault-password-file password_file
docker-compose down
