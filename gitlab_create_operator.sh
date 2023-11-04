kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.7.1/cert-manager.yaml

GL_OPERATOR_VERSION=0.24.1 # https://gitlab.com/gitlab-org/cloud-native/gitlab-operator/-/releases
PLATFORM=kubernetes # or "openshift"
kubectl create namespace gitlab-system
kubectl apply -f https://gitlab.com/api/v4/projects/18899486/packages/generic/gitlab-operator/${GL_OPERATOR_VERSION}/gitlab-operator-${PLATFORM}-${GL_OPERATOR_VERSION}.yaml

#kubectl apply -f https://gitlab.com/api/v4/projects/18899486/packages/generic/gitlab-operator/0.24.1/gitlab-operator-kubernetes-0.24.1.yaml


