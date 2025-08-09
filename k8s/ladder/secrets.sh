#!/usr/bin/env bash

# https://github.com/dani-garcia/vaultwarden/wiki/SMTP-Configuration
kubectl create secret generic vaultwarden-smtp \
    --from-literal=host='' \
    --from-literal=from='' \
    --from-literal=username='' \
    --from-literal=password=''

# https://github.com/dani-garcia/vaultwarden/wiki/Enabling-admin-page
kubectl create secret generic vaultwarden-admin \
    --from-literal=admin-token=''

# https://github.com/dani-garcia/vaultwarden/wiki/Enabling-Mobile-Client-push-notification
kubectl create secret generic vaultwarden-push-notification \
    --from-literal=id='' \
    --from-literal=key=''
