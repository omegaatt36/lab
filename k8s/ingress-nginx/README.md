ingress-nginx
===

see https://kubernetes.github.io/ingress-nginx/deploy/

1. get
```shell
helm show values ingress-nginx --repo https://kubernetes.github.io/ingress-nginx > values.yaml
```

2. modify values.yaml

3. install
```
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --values values.yaml
  ```
