IMAGE   ?= ab1997/slack-notification-resource
VERSION ?= dev

install:
	docker run --rm --privileged docker/binfmt:66f9012c56a8316f9244ffd7622d7c21c1f6f28d
	docker buildx create --name mybuilder

build: install
	docker buildx build --platform linux/amd64,linux/arm64 \
	  --build-arg BUILD_DATE="$(shell date -u --iso-8601)" \
	  --build-arg VCS_REF="$(shell git rev-parse --short HEAD)" \
	  --build-arg vERSION="$(VERSION)" \
	  . -t $(IMAGE):$(VERSION)

push: build
	docker push $(IMAGE):$(VERSION)

release: build
	docker tag $(IMAGE):$(VERSION) $(IMAGE):latest
	docker push $(IMAGE):latest
	docker push $(IMAGE):$(VERSION)
