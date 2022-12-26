.PHONY: up
up:
	docker-compose up --detach --force-recreate --renew-anon-volumes

.PHONY: down
down:
	docker-compose down --volumes

.PHONY: logs
logs:
	docker-compose logs --follow

.PHONY: swarm-up
swarm-up:
	cat docker-compose-swarm.yml | docker stack deploy --compose-file=- plone

.PHONY: swarm-down
swarm-down:
	docker stack rm plone

.PHONY: swarm-logs
swarm-logs:
	docker service logs -f $$(docker stack services plone --quiet --filter name=plone_backend)

.PHONY: image
image:
	docker build -t plone-backend:local .
