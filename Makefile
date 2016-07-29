all: test

IMAGE = mbodenhamer/echoserver

TEST = docker run --rm -it -v $(CURDIR):/app -v /tmp:/tmp \
	-v /var/run/docker.sock:/var/run/docker.sock \
	mbodenhamer/docker-test:1.9.1

#-------------------------------------------------------------------------------

build:
	$(TEST) docker build -t $(IMAGE):latest .

shell:
	docker run --rm -it $(IMAGE):latest bash

.PHONY: build shell
#-------------------------------------------------------------------------------

test-shell:
	$(TEST) bash

quick-test:
	$(TEST) bats tests

example:
	docker run -d --name echo -e LISTEN_PORTS=5000,5001 \
	    -p 5000:5000 -p 5001:5001 $(IMAGE)

test:
	$(MAKE) build
	$(MAKE) quick-test

.PHONY: test-shell quick-test test
#-------------------------------------------------------------------------------
