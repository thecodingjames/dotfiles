# Requirements

- git

> Setup extracted from <https://www.atlassian.com/git/tutorials/dotfiles>

# Installation

```
wget -qO- https://raw.githubusercontent.com/thecodingjames/dotfiles/refs/heads/main/.dotfiles-scripts/sync.sh | bash

bash $HOME/.dotfiles-scripts/setup.sh
```

# Testing

Users

- root:root
- vagrant:vagrant

Make sure to create the VM to install Gnome first, then reboot to launch install script.

```
vagrant up
vagrant reload && vagrant ssh -- '/home/vagrant/.dotfiles-modules/install.sh'
```

To avoid resetting the VM entirely between iterations, use `vagrant reload --provision`, otherwise `vagrant destroy -f && vagrant up` will configure a new VM from scratch.

A Vagrant VM allows to easily tests changes to the config. To disable VirtualBox's GUI set `DF_NO_UI` when booting the VM.

```
DF_NO_UI=1 vagrant up
```

Testing uses local files when booting the VM, but it's also possible to validate the sync script from git using `DF_TEST_SYNC`

```
DF_TEST_SYNC=1 DF_NO_UI=1 vagrant up --provision
```

Complete fresh test command

```
vagrant destroy -f; vagrant up; vagrant reload; vagrant ssh -- '/home/vagrant/.dotfiles-modules/install.sh'
```

# Architecture


here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

```
as_root 'apt-get -qq -y install \
  vim \
  tmux \
  fzf \
  xclip \
  zip \
  unzip \
'
```

VERBOSE=...
/dev/stdout
/path/to/file


