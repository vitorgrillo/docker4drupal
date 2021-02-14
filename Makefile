PARENT_DIR 					:= $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../)
ENVIRONMENT_DIR 			:= $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PROJECT_CMS_DIRECTORY				:= $(PARENT_DIR)/{{PROJECT_NAME}}

CONTAINER_{PROJECT_NAME}			:= web-{PROJECT_NAME}
CONTAINER_DATABASE_{PROJECT_NAME} 	        := db-{PROJECT_NAME}

# targets
.PHONY: default
default: help

## This help message
.PHONY: help
help:
	@printf "Usage: make [target]\n";

	@awk '{ \
			if ($$0 ~ /^.PHONY: [a-zA-Z\-\_0-9]+$$/) { \
				helpCommand = substr($$0, index($$0, ":") + 2); \
				if (helpMessage) { \
					printf "\033[36m%-20s\033[0m %s\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^[a-zA-Z\-\_0-9.]+:/) { \
				helpCommand = substr($$0, 0, index($$0, ":")); \
				if (helpMessage) { \
					printf "\033[36m%-20s\033[0m %s\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^##/) { \
				if (helpMessage) { \
					helpMessage = helpMessage"\n                     "substr($$0, 3); \
				} else { \
					helpMessage = substr($$0, 3); \
				} \
			} else { \
				if (helpMessage) { \
					print "\n                     "helpMessage"\n" \
				} \
				helpMessage = ""; \
			} \
		}' \
		$(MAKEFILE_LIST)

## Builds, (re)creates, starts, and attaches to containers for a service
.PHONY: start
start:
	@docker-compose up --force-recreate -d --remove-orphans

## Initial setup
.PHONY: setup
setup: create-env

## Rebuild images
.PHONY: rebuild
rebuild: stop
	@docker-compose up --build -d

### Connect in Container
.PHONY: ssh
 ssh:
	@docker exec -it ${CONTAINER_{PROJECT_NAME}} bash

## Stop and removes containers, networks, volumes, and images created by up
.PHONY: stop
stop:
	@docker-compose down

## Guess what! :-)
.PHONY: restart
restart: stop start

## Show container logs
.PHONY: logs-web
logs-web:
	@docker container logs $(CONTAINER_{PROJECT_NAME}) --follow

## Interact within the container
.PHONY: interact-web
interact-web:
	@docker container exec -it $(CONTAINER_{PROJECT_NAME}) bash

## Create env
.PHONY: create-env
create-env:
	@cat .env-sample | \
	sed \
	    -e 's#{{CONTAINER_{PROJECT_NAME}}}#${CONTAINER_{PROJECT_NAME}}#g' \
		-e 's#{{CONTAINER_PROJECT_VOLUME}}#${PROJECT_CMS_DIRECTORY}#g' \
		-e 's#{{CONTAINER_{PROJECT_NAME}_DATABASE}}#${CONTAINER_DB_{PROJECT_NAME}}#g' \
		> .env

.DEFAULT_GOAL := default
