USE_SUDO := $(shell which docker >/dev/null && docker ps 2>&1 | grep -q "permission denied" && echo sudo)
DOCKER := $(if $(USE_SUDO), sudo docker, docker)
DIRNAME := $(notdir $(CURDIR))
HAS_NVIDIA_GPU := $(shell which nvidia-smi >/dev/null && nvidia-smi --query --display=COMPUTE && echo ok)

build:
ifdef HAS_NVIDIA_GPU
	$(DOCKER) build . --tag $(DIRNAME)
else
	$(DOCKER) build . --file Dockerfile-cpu --tag $(DIRNAME)
endif

up:
ifdef HAS_NVIDIA_GPU
	$(DOCKER) compose -f docker-compose.yml -f docker-compose.gpu.yml up
else
	$(DOCKER) compose -f docker-compose.yml up
endif

down:
	$(DOCKER) compose down

MODEL_NAME := \
	DeepSeek-R1-Distill-Qwen-7B-Q5_K_M

.PHONY: $(MODEL_NAME)
$(MODEL_NAME):
	cd models && ../docker-entrypoint.sh $@

list-models:
	@echo "Available models:"
	@echo "$(MODELS)" | tr ' ' '\n' | sed 's/^/- /'