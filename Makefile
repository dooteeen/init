#!/usr/bin/make

update: gitconfig clean build_all

gitconfig:
	@git config --local core.hooksPath .githooks
	@git config --local core.whitespace -blank-at-eof

clean:
	@rm -rf ./bin/*

build_all: export_hooks build_init build_deploy

hooks := ./hooks.sh
export_hooks:
	@echo
	> ${hooks}
	grep -hE '^first_hook_.*()' *.sh \
		| sed 's/first_hook_\(.*\)() {/export -f first_hook_\1/g' \
		| sort \
		| xargs -I {} echo {} >> ${hooks}
	grep -hE '^pre_hook_.*()' *.sh \
		| sed 's/pre_hook_\(.*\)() {/export -f pre_hook_\1/g' \
		| sort \
		| xargs -I {} echo {} >> ${hooks}
	grep -hE '^post_hook_.*()' *.sh \
		| sed 's/post_hook_\(.*\)() {/export -f post_hook_\1/g' \
		| sort \
		| xargs -I {} echo {} >> ${hooks}
	echo >> ${hooks}

init := ./bin/init
build_init:
	@echo
	echo '#!/bin/bash' > ${init}
	cat ./core.sh >> ${init}
	find . -maxdepth 1 -name '*.sh' \
		-not -name 'core.sh' \
		-not -name 'hooks.sh' \
		-not -name 'main.sh' \
		| sort \
		| xargs -I {} cat {} >> ${init}
	cat ./hooks.sh >> ${init}
	cat ./main.sh  >> ${init}
	echo 'check_dependencies sed || exit 1' >> ${init}
	echo 'check_dependencies tr  || exit 1' >> ${init}
	echo 'pre_hooks'          >> ${init}
	echo 'install_essentials' >> ${init}
	echo '#install_brew'      >> ${init}
	echo '#install_snap'      >> ${init}
	echo '#install_yay'       >> ${init}
	echo 'install_extras'     >> ${init}
	echo 'clone_dotfiles'     >> ${init}
	echo 'post_hooks'         >> ${init}

deploy := ./bin/deploy
build_deploy:
	@echo
	echo '#!/bin/bash' > ${deploy}
	cat ./core.sh >> ${deploy}
	find . -maxdepth 1 -name '*.sh' \
		-not -name 'core.sh' \
		-not -name 'hooks.sh' \
		-not -name 'main.sh' \
		| sort \
		| xargs -I {} cat {} >> ${deploy}
	cat ./hooks.sh >> ${deploy}
	cat ./main.sh  >> ${deploy}
	echo 'check_dependencies sed || exit 1' >> ${deploy}
	echo 'check_dependencies tr  || exit 1' >> ${deploy}
	echo 'pre_hooks'        >> ${deploy}
	echo 'clone_dotfiles'   >> ${deploy}
	echo 'post_hooks'       >> ${deploy}

test := ./test/test.sh
test:
	@echo '#!/bin/bash' > ${test}
	@cat ./core.sh >> ${test}
	@cat ./main.sh >> ${test}
	@cat ./test/util.sh >> ${test}
	@find . -wholename './test/*.sh' \
		-not -wholename "${test}" \
		-not -wholename "./test/util.sh" \
		| sort \
		| xargs -I {} cat {} >> ${test}
	@bats --tap ./test/test.bats
	@rm ${test}

.PHONY: test
