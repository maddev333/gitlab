helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --set global.hosts.domain=kubemaster.me \
  --set global.hosts.externalIP=172.191.188.83 \
  --set certmanager-issuer.email=me@example.com \
  --set postgresql.image.tag=13.6.0 \
  --set nginx-ingress.enabled=false \
  --set global.ingress.class=traefik
