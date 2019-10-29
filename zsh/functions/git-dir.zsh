#!/usr/bin/env zsh

#
# Displays the path to the Git directory.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

function git-dir {

	local git_dir="${$(command git rev-parse --git-dir):A}"

	if [[ -n "$git_dir" ]]; then
		print "$git_dir"
		return 0
	else
		print "$0: not a repository: $PWD" >&2
		return 1
	fi

}
