#!/bin/bash

# this does not account for the git password.

echo -n "enter your global git email address: "; read
echo You typed ${REPLY}; email_address="${REPLY}"

echo -n "enter your global git name: "; read
echo You typed ${REPLY}; git_name="${REPLY}"

echo -n "recording the git configs globally..."
git config --global user.email "$email_address"
git config --global user.name "$git_name"

echo "done."