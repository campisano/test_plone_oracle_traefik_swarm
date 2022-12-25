# Use with docker-compose

* Start the stack:
```
make up
```

* See the logs:
```
make logs
```

* Remove the stack
```
make down
```



# Use with Docker Swarm

* Init a local swarm cluster:

```
docker swarm init
docker node ls
```

Create external network for the proxy (edge-net)

```
docker network create -d overlay edge-net
```

* Start (or update) the stack:
```
make swarm-up
```

* See the logs:
```
make swarm-logs
```

* Remove the stack:
```
make swarm-down
```

* To end the swarm cluster:
```
docker swarm leave -f
```
