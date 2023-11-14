REPO_NAME := $(shell basename `git rev-parse --show-toplevel` | tr '[:upper:]' '[:lower:]')
DOCKER_REGISTRY := mathematiguy
IMAGE := ${REPO_NAME}.sif
RUN ?= singularity exec ${FLAGS} ${IMAGE}
FLAGS ?=  -B $$(pwd):/code --pwd /code
SINGULARITY_ARGS ?=

.PHONY: sandbox container shell root-shell docker docker-push docker-pull enter enter-root

jupyter:
	${RUN} jupyter lab --ip 0.0.0.0 --port=8888

REMOTE ?= cn-f001
push:
	rsync -rvahzP ${IMAGE} ${REMOTE}.server.mila.quebec:${SCRATCH}

${REPO_NAME}_sandbox:
	singularity build --sandbox ${REPO_NAME}_sandbox ${IMAGE}

sandbox: ${REPO_NAME}_sandbox
	sudo singularity shell --writable ${REPO_NAME}_sandbox

container: ${IMAGE}
${IMAGE}: requirements.txt
	sudo singularity build ${IMAGE} ${SINGULARITY_ARGS} Singularity

shell:
	singularity shell ${FLAGS} ${IMAGE} ${SINGULARITY_ARGS}

root-shell:
	sudo singularity shell ${FLAGS} ${IMAGE} ${SINGULARITY_ARGS}
