#!/usr/bin/env bash

set -eu

[ "$USER" = "root" ] && abort "Run this as yourself, not root."

DIR="$(cd `dirname $0` && pwd)"
cd "$DIR"

DEFAULT_DIRS=(~/bin ~/Dev ~/.gnupg ~/.ssh ~/.macos)

function info() {
	echo -e "\n\033[0;32m➤ $1\033[0m"
}

function directories() {
	info "Creating default directories…"
	for d in "${DEFAULT_DIRS[@]}"; do
		echo "$d"
		mkdir -p "$d"
	done
}

function dotfiles() {
	info "Linking dotfiles…"
	for f in $(find "$DIR/home" -type f) ; do
		echo "$f to ~/${f#"$DIR/home/"}"
		ln -sF "$f" ~/${f#"$DIR/home/"}
	done
}

function settings() {
	info "Linking app settings…"
	info "Skipped for now"
	# ln -sF $DIR/settings/vscode/*.json ~/Library/Application\ Support/Code/User/
}

function macos() {
	info "Applying macOS settings…"
	./macos
}

function homebrew() {
	info "Installing Brew…"

	if ! type brew >/dev/null 2>/dev/null; then
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	else
		echo "Brew already installed"
		return
	fi;

	info "Bundling Brewfile…"
	brew bundle --file=./Brewfile
	brew cleanup

	# change shell to updated brew zsh
	local shell_path="/usr/local/bin/zsh"
	info "Changing shell to '$shell_path'"
	if [ $SHELL != $shell_path ]; then
		if ! grep "$shell_path" /etc/shells > /dev/null 2>&1 ; then
			sudo sh -c "echo $shell_path >> /etc/shells"
		fi
		chsh -s "$shell_path"
	fi
}

function zsh() {
	info "Setting up zsh"

	if [ -d ~/.oh-my-zsh ]; then
		echo "zsh already installed"
	else
	    git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
	fi

	if [ -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]; then
		echo "powerlevel10k already installed"
	else
	    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
	    curl -L https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf -o ~/Library/Fonts/Sauce\ Code\ Pro\ Nerd\ Font\ Complete.ttf
	    curl -L https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf -o ~/Library/Fonts/Sauce\ Code\ Pro\ Nerd\ Font\ Complete\ Mono.ttf
	fi

}

function privrepo() {
	info "Installing \033[0;31mprivate\033[32m repository"

	if [ ! -d ~/Dev/private/dotfiles ]; then
		git clone git@github.com:koengsen/dotfiles.git ~/Dev/private/dotfiles
	    ~/Dev/private/dotfiles/install.sh
	else
		echo "Repository already checked out"
	fi

}

function install() {
	sudo -v

	privrepo;
	directories;
	homebrew;
	dotfiles;
	zsh;
	settings;
	macos;
	success;
}

function linksonly() {
	settings;
	privrepo;
	dotfiles;
	success;
}

function success() {
	info "Successfully installed!"
}

function helpmenu() {
	cat << EOF
Usage: ./install.sh [--help|-h] [--only-links]

--only-links Only create symlinks for settings/public/private repo
EOF
}

while [ ! $# -eq 0 ]
do
	case "$1" in
		--help | -h)
			helpmenu;
			exit
			;;
		--only-links)
			linksonly;
			exit
			;;
	esac
	shift
done

install;

unset success;
unset linksonly;
unset privrepo;
unset directories;
unset macos;
unset dotfiles;
unset zsh;
unset homebrew;
unset helpmenu;
unset install;
unset info;
