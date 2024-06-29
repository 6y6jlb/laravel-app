export PWD := $(PWD)
NODE_V := 20.9
SHELL = /bin/sh
APP_PATH := $$PWD
APP_CONTAINER_NAME := app
NODE_CONTAINER_NAME := node
docker_bin := $(shell command -v docker 2> /dev/null)
has_composer_v2 := $(shell command docker compose version 2> /dev/null)

ifneq (,$(has_composer_v2))
    # Using docker compose v2
  docker_compose_bin := docker compose
else
    # Using docker compose v1
  docker_compose_bin := $(shell command -v docker-compose 2> /dev/null)
endif

test:
	echo $(APP_PATH)

state: ## show state of all docker images
	$(docker_bin) ps -a

build: ## build all docker images
	$(docker_compose_bin) build

up: ## start application containers
	$(docker_compose_bin) up --no-recreate --detach

install: build up ## build and install application
	$(docker_compose_bin) exec $(APP_CONTAINER_NAME) php artisan key:generate
	make x-composer-install
	make stop

init: up x-composer-install x-database ## start application, refresh configs and helpers
	$(docker_bin) run --rm -v $(APP_PATH):/var/www -w /var/www -u $(id -u):$(id -g) node:$(NODE_V) yarn install
	$(docker_compose_bin) exec $(APP_CONTAINER_NAME) php artisan view:clear

stop: ## stop application containers
	$(docker_compose_bin) stop

down: ## stop and clear application containers
	$(docker_compose_bin) down
	$(docker_bin) volume prune --force


front-watch: up ## interactive mode for editing front files
	docker run --rm -it -v $(APP_PATH):/var/www -w /var/www -u $(id -u):$(id -g) -p 3000:3000 node:$(NODE_V) yarn dev


front-build: up ## build assets to deploy-ready state
	$(docker_bin) run --rm -v $(APP_PATH):/var/www -w /var/www -u $(id -u):$(id -g) node:$(NODE_V) yarn run build

front-install: up ## install dependencies
	$(docker_bin) run --rm -v $(APP_PATH):/var/www -w /var/www -u $(id -u):$(id -g) node:$(NODE_V) yarn install


x-composer-install:
	$(docker_compose_bin) exec $(APP_CONTAINER_NAME) composer install

x-database:
	sleep 5; # waiting for mysql initialization (0_o)'
	$(docker_compose_bin) exec $(APP_CONTAINER_NAME) php artisan db:wipe --database mysql
	$(docker_compose_bin) exec $(APP_CONTAINER_NAME) php artisan migrate:fresh --seed

shell: up ## start shell into application container
	$(docker_compose_bin) exec $(APP_CONTAINER_NAME) bash