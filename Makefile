check-traefik:
ifeq (,$(shell docker ps -f name=^traefik$$ -q))
	$(error docker image traefik is not running)
endif

image:
	@echo "Building docker image"
	docker build --pull --no-cache -t mindhochschulnetzwerk/php-base:latest .

rebuild:
	@echo "Rebuilding docker image"
	docker build -t mindhochschulnetzwerk/php-base:latest .

dev: check-traefik
	@echo "Starting DEV Server"
	docker-compose up -d --force-recreate

docker-push:
	docker push mindhochschulnetzwerk/php-base:latest

shell:
	docker-compose exec php-base sh

logs:
	docker-compose logs -f
