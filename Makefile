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

.PHONY: minikube
minikube:
	@minikube start --addons=default-storageclass, ingress, ingress-dns, storage-provisioner

.PHONY: kube-manifest
kube-manifest:
	kubectl apply -f manifests/v1deploy.yml
	kubectl apply -f manifest/honeycombio.yml