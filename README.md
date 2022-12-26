# Create the Oracle-ready backend docker image

The local backend docker image is ready to be used with an Oracle database like the always-free [Oracle Autonomous Databases](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm#freetier_topic_Always_Free_Resources_Oracle_Database):

```
make image
```

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

* Create the appropriate docker secrets:
```
echo -n 'ADMIN' | docker secret create plone_RELSTORAGE_ORA_USR_v1 -
echo -n 'YOUR_ADMIN_PASSWORD' | docker secret create plone_RELSTORAGE_ORA_PWD_v1 -
echo -n 'test_high' | docker secret create plone_RELSTORAGE_DSN_v1 -
cat YOUR_DOWNLOADED_ORALCE_WALLET_FILE.tgz | base64 | docker secret create plone_TNS_ADMIN_FILEDATA_v1 -
docker secret ls
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
