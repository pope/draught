MAKEFLAGS += --warn-undefined-variables -r -j 4
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail
.DEFAULT_GOAL := all

.SECONDEXPANSION:
.DELETE_ON_ERROR:
.SUFFIXES:
.ONESHELL:
.PHONY: all server
.PHONY: clean really-clean

NPM ?= npm

coffeefiles := $(wildcard web/elements/*.coffee)
jsfiles := $(patsubst %.coffee,%.js,$(coffeefiles))
jsmapfiles := $(patsubst %,%.map,$(jsfiles))
htmlfiles := $(wildcard web/elements/*.html)

all: web/build.html web/build.js

web/%.js web/%.js.map: web/%.coffee node_modules Makefile
	cd web && ../node_modules/coffee-script/bin/coffee -mc $(patsubst web/%,%,$<)

node_modules: package.json
	$(NPM) install
	touch $@

web/components: web/bower.json node_modules
	./node_modules/bower/bin/bower install
	touch $@

server: all
	./node_modules/http-server/bin/http-server web

web/build.html web/build.js: web/components $(jsfiles) $(htmlfiles)
%/build.html %/build.js: web/index.html
	./node_modules/vulcanize/bin/vulcanize -o $@  --csp --inline -s $<

clean:
	-rm web/build.html web/build.js $(jsfiles) $(jsmapfiles)
really-clean: clean
	-rm -rf node_modules web/components
