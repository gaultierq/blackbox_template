#!/bin/bash
set -e

echo "Cloning secret repo" &&
git clone $BLACKBOXGIT secrets && cd secrets && 

# echo "Importing GPG keys $GPG_PRIVATE_KEY" &&
gpg2 -v --import <(echo "$GPG_PRIVATE_KEY") &&

echo "Decrypting..." &&
GPG=gpg2 blackbox_postdeploy && 

exec "$@"