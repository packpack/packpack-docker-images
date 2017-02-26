DOCKER_REPO?=packpack/packpack

##

BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
ifeq ("$(BRANCH)","master")
ARCHSUFFIX:=
else
ARCHSUFFIX:=-$(BRANCH)
endif

DOCKERFILES := $(wildcard */*/Dockerfile)
IMAGES := $(subst /,-,$(patsubst %/Dockerfile,%,$(DOCKERFILES)))

all: build
build: $(IMAGES)
push: $(patsubst %,push-%,$(IMAGES))

define IMAGE_template =
$(1): $(subst -,/,$(1))/Dockerfile
	docker build -t $(DOCKER_REPO):$(1)$(ARCHSUFFIX) $$(dir $$<)
push-$(1): $(1)
	docker push $(DOCKER_REPO):$(1)$(ARCHSUFFIX)
endef

$(foreach image,$(IMAGES),$(eval $(call IMAGE_template,$(image))))
