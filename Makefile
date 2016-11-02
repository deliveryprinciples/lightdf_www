IMG_NAME = lightdf_www
VERSION = 0.1
DEV_DIR = /Users/andrew/Code/LightDF/lightdf_www
CONTAINER_DIR = /usr/share/nginx/html/
PUBLIC_DIR = test/
CONTAINER_NAME = lightdf_www
CONTAINER_BIN_DIR = /usr/bin
PORT_EXPOSE = 80
PORT_INTERNAL = 80
DOCKERHUB_UID = lightdf
LINK_TO_CONTAINER = lightdf_framework# This is the way we connect docker containers together so that data is shared between them.

.PHONY: build push shell run start stop rm release

build:
	docker build -t $(IMG_NAME):$(VERSION) $(DEV_DIR)

runDev:
	docker run -d --name $(CONTAINER_NAME) -p $(PORT_EXPOSE):$(PORT_INTERNAL) --link $(LINK_TO_CONTAINER):$(LINK_TO_CONTAINER) -v $(DEV_DIR)/public:$(CONTAINER_DIR)/$(PUBLIC_DIR) $(IMG_NAME):$(VERSION)

runProd:
	docker run -d --name $(CONTAINER_NAME) -p $(PORT_EXPOSE):$(PORT_INTERNAL) --link $(LINK_TO_CONTAINER):$(LINK_TO_CONTAINER) $(IMG_NAME):$(VERSION)

stop:
	-docker stop $(CONTAINER_NAME)
	-docker rm $(CONTAINER_NAME)

start:
	docker start $(CONTAINER_NAME)

restart: stop run

rm:
	-docker rmi $(IMG_NAME):$(VERSION)
	-docker rmi $(DOCKERHUB_UID)/$(CONTAINER_NAME):$(VERSION)

clean:
	-docker images|grep \<none\>|awk '{print $$3}' | xargs docker rmi

shell:
	docker exec -it $(CONTAINER_NAME) /bin/sh

test_connection:
	@echo "v---- Testing a basic web connectivity (to the container) ----v"
	curl http://localhost:$(PORT_EXPOSE)/$(PUBLIC_DIR)
	@if [ $$? -eq 0 ] ; then echo "Success: basic web connection test passed" ; fi
	@echo "^---- Basic web connecivity test complete ----^"

test_static:
	@echo "v---- Static check of javascript syntax (jshint) ----v"
	@jshint --extract=auto public/*.html
	@if [ $$? -eq 0 ] ; then echo "Success: linting complete without errors" ; fi

test: test_static test_connection

push:
	docker commit $(CONTAINER_NAME) $(DOCKERHUB_UID)/$(CONTAINER_NAME):$(VERSION)
	docker push $(DOCKERHUB_UID)/$(CONTAINER_NAME):$(VERSION)

run: runDev

default: runDev
