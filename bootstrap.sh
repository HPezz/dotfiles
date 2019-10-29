#!/usr/bin/env zsh

# # Symlink files in $HOME

# # Install config
# typeset -U config_dirs
# config_dirs=(
# 	git
# 	zsh
# )

#
# Helpers
#

function echo_and_run {
	echo "$@"
	$@
}

function run_script {
	if [[ "$arg_array" =~ "--$1" ]]; then
	shift
	echo $1
	shift
	echo_and_run $@
	fi
}

#
# Arguments
#

arg_array=($@)
available_args=("--hello" "--macos" "--brew" "--zsh" "--git" "--symlink")

#
# Check if arguments have been passed
#

if [ ${#arg_array[@]} -eq 0 ]; then
	echo "⚠️  No arguments have been passed."
	echo "Please try again with one of those: $available_args"
	return 1
fi

#
# Check if all arguments exist, if not exit
#

for arg in $arg_array; do
	if [[ ! " ${available_args[@]} " =~ " ${arg} " ]]; then
		echo "⚠️  Unrecognized argument: $arg"
		echo "Please try again with one of those: $available_args"
		return 1
	fi
done

#
# Sudo power
#

if [[ "$@" =~ "--macos" || "$@" =~ "--brew" ]]; then
	if ! sudo -n true 2>/dev/null; then
		echo "⚠️  Please enter your password as some scripts require sudo access."
		sudo -v
	fi
fi

#
# Hello, World! -- test argument
#

# if [[ "$@" =~ "--hello" ]]; then
# 	echo "Hello, World!"
# 	echo_and_run ls -al $HOME
# fi

run_script "hello" "Hello, World!" ls -al $HOME

#
# macOS
#

if [[ "$@" =~ "--macos" ]]; then
	echo "Running macOS configuration script"

	# Set macOS defaults
	zsh ./scripts/macos.sh
fi

#
# Brew
#

if [[ "$@" =~ "--brew" ]]; then
	echo "Running brew configuration script"

	# Install formulae & casks
	zsh ./scripts/brew.sh

	# Switch to using brew-installed zsh as default shell
	# if ! fgrep -q "${BREW_PREFIX}/bin/zsh" /etc/shells; then
	#   echo "${BREW_PREFIX}/bin/zsh" | sudo tee -a /etc/shells;
	#   chsh -s "${BREW_PREFIX}/bin/zsh";
	# fi;
fi

#
# Zsh
#

if [[ "$@" =~ "--zsh" ]]; then
	echo "Running zsh configuration script"
	ln -s $PWD/symlink/.zshenv $HOME/.zshenv
fi

#
# Git
#

if [[ "$@" =~ "--git" ]]; then
	echo "Running git configuration script"
	ln -s $PWD/git ${XDG_CONFIG_HOME:-$HOME/.config}/
fi
