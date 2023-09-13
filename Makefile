FLASK_APP=src/app
FLASK_ENV=dev
PYTHONUNBUFFERED=true

IMAGE=alexmavcouk/blog-app
VERSION:=$(shell date +'%Y%m%d%H%M%S')

DOCKER_USER=alexmavcouk
DOCKER_PASSWORD=$(shell pass show docker_hub_personal)

.PHONY: install-local
install-local:
	@pip3 install -r requirements.txt

.PHONY: install-env
install-env:
	@pipenv install && \
	pipenv shell

.PHONY: uninstall-env
uninstall-env:
	@pipenv uninstall --all && ./scripts/uninstall.sh

.PHONY: update-env
update-env:
	@pipenv uninstall --all && ./scripts/uninstall.sh \
	&& ./scripts/run.sh \
	&& pipenv install

.PHONY: envs
envs:
	./scripts/run.sh

.PHONY: run
run:
	@flask run

.PHONY: trace-start
trace-start:
	@opentelemetry-instrument python3 src/app.py

.PHONY: trace
trace:
	@opentelemetry-instrument --traces_exporter console \
		flask run --debug

.PHONY: docker-build
docker-build:
	echo "$(DOCKER_PASSWORD)" | docker login -u $(DOCKER_USER) --password-stdin
	docker buildx build --builder mybuilder -t $(IMAGE):$(VERSION) . --push --platform linux/amd64,linux/arm64
# docker push $(IMAGE):$(VERSION)

# Make commands in Kubernetes below onwards. 

calico:
	kubectl create namespace tigera-operator
	helm install calico projectcalico/tigera-operator --version v3.25.1 --namespace tigera-operator

eks-nginx:
	kubectl create namespace ingress-nginx
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm repo update
	helm install ingress-nginx ingress-nginx/ingress-nginx \
		--namespace ingress-nginx \
		--set controller.replicaCount=2 \
		--set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
		--set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux


.PHONY: minikube
minikube:
	@minikube start --addons=default-storageclass, ingress, ingress-dns, storage-provisioner

.PHONY: kube-manifest
kube-manifest:
	kubectl apply -f manifests/v1deploy.yml
	kubectl apply -f manifest/honeycombio.yml

# Make Demo
demo-build:
	echo "$(DOCKER_PASSWORD)" | docker login -u $(DOCKER_USER) --password-stdin
	docker buildx build --builder mybuilder -t $(IMAGE)-demo:$(VERSION) . --push --platform linux/amd64,linux/arm64

.PHONY: demo-start
demo-start:
	minikube start -p cluster1
	minikube start -p cluster2
	minikube start --addons=default-storageclass, storage-provisioner
	minikube addons enable ingress

demo-update:
	kubectl apply -f manifests/demoManifest.yml
	kubectl apply -f manifests/demoHoneyio.yml

demo-stop:
	minikube stop
	minikube stop -p cluster1
	minikube stop -p cluster2

demo-delete:
	minikube delete --all

con-mini:
	kubectl config use-context minikube

con-c1:
	kubectl config use-context cluster1
	kubectl create deployment test-deploy-cluster1 --image=nginx 

con-c2:
	kubectl config use-context cluster2
	kubectl create deployment test-deploy-cluster1 --image=nginx --replicas=13

app-fault:
	kubectl apply -f manifests/demoDeploy.yml

app-fix:
	kubectl replace -f manifests/demoDeployFix.yml