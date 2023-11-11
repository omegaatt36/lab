#!/usr/bin/env bash

# https://github.com/dani-garcia/vaultwarden/wiki/SMTP-Configuration
kubectl create secret generic smtp \
    --from-literal=host='' \
    --from-literal=from='' \
    --from-literal=username='' \
    --from-literal=password=''

# https://github.com/dani-garcia/vaultwarden/wiki/Enabling-admin-page
kubectl create secret generic vaultwarden \
    --from-literal=admin-token=''

# https://github.com/dani-garcia/vaultwarden/wiki/Enabling-Mobile-Client-push-notification
kubectl create secret generic push-notification \
    --from-literal=id='' \
    --from-literal=key=''