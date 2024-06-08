local_docker_registry := "k3d-registry.localhost:5001"
image := "healthysaw"
tag := "healthysaw-" + `git rev-parse --short HEAD`

set export

[private]
default:
    @just --list

# Create k3d cluster for local testing
k3d:
  k3d registry create registry.localhost --port 5001
  k3d cluster create --registry-use k3d-registry.localhost:5001 #-v "$(PWD)/dist:/data"

install-kuberhealthy:
  kubectl create namespace kuberhealthy --dry-run=client -oyaml | kubectl apply -f -
  helm repo add kuberhealthy https://kuberhealthy.github.io/kuberhealthy/helm-repos
  helm install -n kuberhealthy kuberhealthy kuberhealthy/kuberhealthy --set image.tag=v2.8.0-rc2

# Run a docker build
build:
  docker build -t {{tag}} .

# Push the locally built image to the local registry for testing
@push-local:
  @echo "Pushing to local registry"
  docker tag {{tag}} {{local_docker_registry}}/{{image}}:latest
  docker push {{local_docker_registry}}/{{image}}:latest

# Run a docker build and push to the local registry
build-and-push-local: build push-local

install-test:
  just template-test | kubectl apply -f -

template-test:
  helm template charts/healthysaw \
    --set image.repository="{{local_docker_registry}}/{{image}}" \
    --set image.tag=latest \
    --set image.pullPolicy=Always \
    --namespace kuberhealthy

run-container:
  just build
  docker run -it --entrypoint sh {{tag}}

# Chain all the necessary commands to run the demo
demo: k3d build-and-push-local install-kuberhealthy install-test