# -*- mode: makefile; tab-width: 4; indent-tabs-mode: 1 -*-
# vim: ts=4 sw=4 ft=make noet

SHELL := /bin/bash

VERSION=0.9
SERVICE=unfs

default: all

.PHONY: all

all: stable

.PHONY: test

test: $(addprefix test-,${VERSION})

.PHONY: test-%

test-%: mubox/${SERVICE}-%
	stdbuf -oL test/run_all.sh $(subst test-,,$@)

.PHONY: mubox/${SERVICE}-%

mubox/${SERVICE}-%:
	if [[ ! $$(docker images --format='{{.Repository}}-{{.Tag}}' $(subst -,:,$@)) =~ "$@" ]]; then \
		docker pull $(subst -,:,$@) || (docker pull $(subst -,:,$@)-beta; docker tag $(subst -,:,$@)-beta $(subst -,:,$@)) \
	fi

.PHONY: stable beta alpha

stable:
	@./util/publish.sh stable

beta:
	@./util/publish.sh beta

alpha:
	@./util/publish.sh alpha
