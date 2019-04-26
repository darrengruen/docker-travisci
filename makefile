SHELL:=/bin/bash

app           ?= travisci
TRAVIS_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD 2> /dev/null || echo "unstable")
build_date    ?= $(shell date -u +%FT%T.%S%Z)
TRAVIS_COMMIT ?= $(shell git rev-parse --short HEAD 2> /dev/null || echo "unstable")
img           ?= ${ns}/${app}:${tag}
ns            ?= gruen
tag           ?= $(shell sed 's|/|_|g' <<< ${TRAVIS_BRANCH})

# ifeq (${tag},master)
  # $(info $${tag}: ${tag})
# endif

.PHONY: build
build:
	docker build \
    --build-arg BRANCH_NAME=${branch} \
    --build-arg BUILD_DATE=${build_date} \
    --build-arg COMMIT_SHA=${commit} \
    -t ${img} .
	
.PHONY: clean
clean:
	docker rmi ${img}

.PHONY: info
info:

.PHONY: lint
lint:
	docker run -i --rm hadolint/hadolint:latest < Dockerfile
	
.PHONY: push
push:
	$(eval base = [0-9]{1,3})
	$(eval match = ^${base}(.${base})?(.${base})?((_|-).*)?)
	echo "${match}"
	[[ ${tag} =~ ${match} ]] && docker push ${img} || echo "No push, not a version tag"

.PHONY: test
test:
	docker run --rm \
		-v "${PWD}:/test" \
		-v /var/run/docker.sock:/var/run/docker.sock \
		--workdir /test \
		--name ${app}_container_structure_test \
		gcr.io/gcp-runtimes/container-structure-test:latest \
			test \
			--image ${img} \
			--config /test/test.yaml

ifndef VERBOSE
.SILENT:
endif
