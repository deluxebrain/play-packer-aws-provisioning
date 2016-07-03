# Getting started

```shell
# instal vault
brew install vault

# fire up dev (in-memory) server
vault server -dev

# set up environment
# then following commands are taken from the stdout of the vault server
# [tmux-prefix] [ then scroll around using cursor keys to find history, then q to quitout
export VAULT_ADDR='http://127.0.0.1:8200'

# save off seal and root token

# verify running
vault status


