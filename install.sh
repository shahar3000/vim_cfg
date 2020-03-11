#!/bin/bash -e

install_ccglue() {
	local ccglue_path=/tmp/ccglue

	git clone https://github.com/giraldeau/ccglue.git $ccglue_path
	pushd $ccglue_path
	git checkout 3fa724b17d854c359e380cc9ee2ad61756696e31

	autoreconf -i
	./configure
	make -j8
	sudo make install
	popd
	rm -rf $ccglue_path
}

install_perquisites() {
	sudo apt update
	sudo apt remove -y vim vim-runtime gvim vim-tiny vim-common vim-gui-common vim-nox
	sudo apt install -y ruby-dev libperl-dev python-dev rake exuberant-ctags cmake cscope bear libclang1 automake autoconf libtool
}

install_vim() {
	local vim_path=/tmp/vim
	local xterm_regex="if \[\[ $TERM == xterm \]\]; then export TERM=xterm-256color; fi"
	local xterm_cmd="if [[ $TERM == xterm ]]; then export TERM=xterm-256color; fi"
	local bashrc_path="/home/$(whoami)/.bashrc"


	git clone https://github.com/vim/vim.git $vim_path
	pushd $vim_path
	git checkout v8.1.2300

	./configure --with-features=huge \
		--enable-multibyte \
		--enable-rubyinterp=yes \
		--enable-pythoninterp=yes \
		--with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
		--enable-perlinterp=yes \
		--enable-luainterp=yes \
		--enable-cscope \
		--prefix=/usr/local

	make -j8
	sudo make install
	popd
	rm -rf $vim_path

	grep -q "^$xterm_regex$" $bashrc_path || echo "$xterm_cmd" >> $bashrc_path
}

set_vim_default_editor() {
	sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
	sudo update-alternatives --set editor /usr/local/bin/vim
	sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
	sudo update-alternatives --set vi /usr/local/bin/vim
}

post_cfg() {
	local base_dir="$(realpath $(dirname "${BASH_SOURCE[0]}"))"

	pushd $base_dir/vundle_plugins/command-t
	rake make
	popd
}

install_perquisites
install_vim
set_vim_default_editor
install_ccglue
post_cfg
