#!/bin/bash

#
# Description
# 	- Run this script with sudo
#	- Sets up dev environment with:
#		- Docker
#		- LazyDocker
#		- Git
#		- Neovim
#		- Tmux
#		- NodeJS
#		- Go
#

GET_DOCKER=true
GET_LAZYDOCKER=true
GET_GIT=true
GET_GH_CLI=true
GET_NEOVIM=true
GET_TMUX=true
GET_NODE=true
NODE_VERSION=22
GET_GO=true


# 0. Updates
sudo apt-get update

# 1. Docker
## Run the docker convenience script. More info: https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script
if [ "$GET_DOCKER" == true ]; then
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh ./get-docker.sh
fi

# 2. LazyDocker
if [ "$GET_LAZYDOCKER" == true ]; then
	curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
fi

# 3. Git
if [ "$GET_GIT" == true ]; then
	sudo apt install git-all
fi

# 4. GH CLI

if [ "$GET_GH_CLI" == true ]; then
	# https://github.com/cli/cli/blob/trunk/docs/install_linux.md
	(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
		&& sudo mkdir -p -m 755 /etc/apt/keyrings \
		&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
		&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
		&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
		&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
		&& sudo apt update \
		&& sudo apt install gh -y

	# now login
	gh auth login
fi

# 5. Neovim
if [ "$GET_NEOVIM" == true ]; then
	sudo apt install neovim
fi

# 6. Tmux
if [ "$GET_TMUX" == true ]; then
	sudo apt install tmux
fi

# 7. NodeJS
if [ "$GET_NODE" == true ]; then
	## Download and install nvm:
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

	## in lieu of restarting the shell
	\. "$HOME/.nvm/nvm.sh"

	## Download and install Node.js
	nvm install $NODE_VERSION

	## Verify the Node.js version:
	node -v # Should print "v22.16.0".
	nvm current # Should print "v22.16.0".

	## Verify npm version:
	npm -v # Should print "10.9.2".
fi

