.PHONY: up
up:
	docker-compose --file docker-compose.yml --project-directory . up --detach --force-recreate --renew-anon-volumes

.PHONY: down
down:
	docker-compose --file docker-compose.yml --project-directory . down --volumes

.PHONY: logs
logs:
	docker-compose --file docker-compose.yml --project-directory . logs --follow

.PHONY: swarm-up
swarm-up:
	cat swarm-stack.yml | docker stack deploy --compose-file=- plone

.PHONY: swarm-down
swarm-down:
	docker stack rm plone

.PHONY: swarm-logs
swarm-logs:
	docker service logs --follow $$(docker stack services plone --quiet --filter name=plone_backend)

.PHONY: image
image:
	./frontend/ci/build.sh
	./backend/ci/build.sh
