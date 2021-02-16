check-traefik:
ifeq (,$(shell docker ps -f name=^traefik$$ -q))
	$(error docker image traefik is not running)
endif

image:
	@echo "Building docker image"
	docker-compose build --pull --no-cache

dev: check-traefik
	@echo "Starting DEV Server"
	docker-compose up -d --force-recreate
