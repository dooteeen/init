#!/usr/bin/make

update: clean init build_all

clean:
	@rm -rf ./bin

init:
	@mkdir ./bin

build_all: build_main

build_main:
	@echo '#!/bin/bash' > ./bin/script
	@cat ./core.sh >> ./bin/script
	@cat ./dotfiles.sh >> ./bin/script
	@find . -name '*.sh' \
		-not -name 'core.sh' \
		-not -name 'dotfiles.sh' \
		-not -name 'main.sh' \
		| sort \
		| xargs -I {} cat {} >> ./bin/script

