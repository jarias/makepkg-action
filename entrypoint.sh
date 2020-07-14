#!/bin/bash

set -e

chmod -R a+rw .

sudo -u build sh -c "echo \"$GPG_PRIVATE_KEY\" > private.key"
sudo -u build sh -c "gpg --import --batch --yes private.key"
sudo -u build sh -c "echo 'default-cache-ttl 7200' > ~/.gnupg/gpg-agent.conf"
sudo -u build sh -c "echo 'max-cache-ttl 31536000' >> ~/.gnupg/gpg-agent.conf"
sudo -u build sh -c "echo 'allow-preset-passphrase' >> ~/.gnupg/gpg-agent.conf"
sudo -u build sh -c "gpg-connect-agent RELOADAGENT /bye"
sudo -u build sh -c "gpg-connect-agent 'PRESET_PASSPHRASE $GPG_KEY_GRIP -1 $GPG_KEY_PASSPHRASE' /bye"
sudo -u build sh -c "makepkg --sign --syncdeps --noconfirm"
ls -l
aws configure list
mkdir -p local-repo
aws s3 sync --follow-symlinks s3://$BUCKET/repo/x86_64/ local-repo/
chmod -R a+rw local-repo
sudo -u build sh -c "repo-add -s local-repo/$REPO.db.tar.gz *.pkg.tar.zst"
find . -maxdepth 1 -name '*.pkg.tar.zst' | xargs -I {} cp {} local-repo/
find . -maxdepth 1 -name '*.pkg.tar.zst.sig' | xargs -I {} cp {} local-repo/
aws s3 sync --follow-symlinks --acl public-read local-repo/ s3://$BUCKET/repo/x86_64/
