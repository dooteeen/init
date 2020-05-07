#!/usr/bin/make

update: clean init build_all

clean:
	@rm -rf ./bin

init:
	@mkdir ./bin

build_all: build_init build_init_brew build_init_yay build_deploy

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
	echo 'install_extras'     >> ${init}
	echo 'clone_dotfiles'     >> ${init}
	echo 'post_hooks'         >> ${init}

init_brew := ./bin/init_with_brew
build_init_brew:
	@echo
	echo '#!/bin/bash' > ${init_brew}
	cat ./core.sh >> ${init_brew}
	find . -name '*.sh' \
		-not -name 'core.sh' \
		-not -name 'main.sh' \
		| sort \
		| xargs -I {} cat {} >> ${init_brew}
	cat ./main.sh >> ${init_brew}
	echo 'pre_hooks'          >> ${init_brew}
	echo 'install_essentials' >> ${init_brew}
	echo 'install_brew'       >> ${init_brew}
	echo 'install_extras'     >> ${init_brew}
	echo 'clone_dotfiles'     >> ${init_brew}
	echo 'post_hooks'         >> ${init_brew}

init_yay := ./bin/init_with_yay
build_init_yay:
	@echo
	echo '#!/bin/bash' > ${init_yay}
	cat ./core.sh >> ${init_yay}
	find . -name '*.sh' \
		-not -name 'core.sh' \
		-not -name 'main.sh' \
		| sort \
		| xargs -I {} cat {} >> ${init_yay}
	cat ./main.sh >> ${init_yay}
	echo 'pre_hooks'          >> ${init_yay}
	echo 'install_essentials' >> ${init_yay}
	echo 'install_yay'        >> ${init_yay}
	echo 'install_extras'     >> ${init_yay}
	echo 'clone_dotfiles'     >> ${init_yay}
	echo 'post_hooks'         >> ${init_yay}

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

