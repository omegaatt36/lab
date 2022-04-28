prometheus helm deploy
===

[source](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus)

1. add helm chart
    ```bash
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    ```
2. create pv & pvc
    ```bash
    k apply -f pv-pve.yaml
    ```
3. install
    ```bash
    helm install prometheus prometheus-community/prometheus -f values.yaml
    ```
