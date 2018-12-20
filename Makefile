SHELL=/bin/bash
MANIFEST=./manifest
IMAGE=redis:5
NAMESPACE=default
NAME=gmt-redis
CLAIM_NAME=${NAME}-data
LABELS_KEY=app
LABELS_VALUE=gmt-redis-test
IMAGE_PULL_POLICY=IfNotPresent

all: deploy

build:
	@docker build -t ${IMAGE} .

push:
	@docker push ${IMAGE}

cp:
	@find ${MANIFEST} -type f -name "*.sed" | sed s?".sed"?""?g | xargs -I {} cp {}.sed {}

sed:
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.name}}"?"${NAME}"?g
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.namespace}}"?"${NAMESPACE}"?g
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.port}}"?"${PORT}"?g
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.image}}"?"${IMAGE}"?g
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.image.pull.policy}}"?"${IMAGE_PULL_POLICY}"?g
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.labels.key}}"?"${LABELS_KEY}"?g
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.labels.value}}"?"${LABELS_VALUE}"?g
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.claim.name}}"?"${CLAIM_NAME}"?g

deploy: OP=create
deploy: cp sed
	@kubectl ${OP} -f ${MANIFEST}/.

clean: OP=delete
clean:
	@kubectl ${OP} -f ${MANIFEST}/.
