#!/usr/bin/make

update: clean init build_all

clean:
	@rm -rf ./bin

init:
	@mkdir ./bin

build_all: extract_hooks build_init build_deploy

hooks := ./hooks
extract_hooks:
	grep -hE '^pre_hook_.*()' *.sh \
		| sed 's/pre_hook_\(.*\)() {/export -f pre_hook_\1/g' \
		| sort \
		| xargs -I {} echo {} > ${hooks}
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
		-not -name 'main.sh' \
		| sort \
		| xargs -I {} cat {} >> ${init}
	cat ./hooks >> ${init}
	cat ./main.sh >> ${init}
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
		-not -name 'main.sh' \
		| sort \
		| xargs -I {} cat {} >> ${deploy}
	cat ./hooks >> ${deploy}
	cat ./main.sh >> ${deploy}
	echo 'pre_hooks'        >> ${deploy}
	echo 'clone_dotfiles'   >> ${deploy}
	echo 'post_hooks'       >> ${deploy}

test := ./test/test.sh
test:
	@echo '#!/bin/bash' > ${test}
	@cat ./core.sh >> ${test}
	@find . -wholename './test/*.sh' \
		-not -wholename "${test}" \
		| sort \
		| xargs -I {} cat {} >> ${test}
	@bats --tap ./test/test.bats
	@rm ${test}

.PHONY: test
