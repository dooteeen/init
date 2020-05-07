#!/usr/bin/make

update: clean init build_all

clean:
	@rm -rf ./bin

init:
	@mkdir ./bin

build_all: build_init build_deploy

init := ./bin/init
build_init:
	@echo
	echo '#!/bin/bash' > ${init}
	cat ./core.sh >> ${init}
	find . -name '*.sh' \
		-not -name 'core.sh' \
		-not -name 'main.sh' \
		| sort \
		| xargs -I {} cat {} >> ${init}
	cat ./main.sh >> ${init}
	echo 'pre_hooks'          >> ${init}
	echo 'install_essentials' >> ${init}
	echo '#install_brew'      >> ${init}
	echo '#install_yay'       >> ${init}
	echo 'install_extras'     >> ${init}
	echo 'clone_dotfiles'     >> ${init}
	echo 'post_hooks'         >> ${init}

deploy := ./bin/deploy
build_deploy:
	@echo
	echo '#!/bin/bash' > ${deploy}
	cat ./core.sh >> ${deploy}
	find . -name '*.sh' \
		-not -name 'core.sh' \
		-not -name 'main.sh' \
		| sort \
		| xargs -I {} cat {} >> ${deploy}
	cat ./main.sh >> ${deploy}
	echo 'pre_hooks'        >> ${deploy}
	echo 'clone_dotfiles'   >> ${deploy}
	echo 'post_hooks'       >> ${deploy}

