FLASK_APP=src/app
FLASK_ENV=dev
PYTHONUNBUFFERED=true

IMAGE=blogapp
VERSION:=$(shell date +'%Y%m%d%H%M%S')

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
	@docker build -t $(IMAGE):$(VERSION) .

# Make commands in Kubernetes below onwards. 

.PHONY: minikube
minikube:
	@minikube start --addons=default-storageclass, ingress, ingress-dns, storage-provisioner

.PHONY: kube-manifest
kube-manifest:
	@kubectl apply -f manifests/manifest.yml