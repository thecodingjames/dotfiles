# Installation

By default, uses git source and install all modules
```
wget -qO- https://raw.githubusercontent.com/thecodingjames/dotfiles/refs/heads/main/dotfiles-sync.sh | bash

bash $HOME/dotfiles-install.sh
```

You can also use the `archive` source
```
export SOURCE=archive; wget -qO- https://raw.githubusercontent.com/thecodingjames/dotfiles/refs/heads/main/dotfiles-sync.sh | bash
```

And provide specific modules to install
```
bash $HOME/dotfiles-install.sh terminal cli-apps
```

Configs are saved to `.dotfiles-config`, so next time *sync* and *install* will reuse the same values.


# Update

```
./$HOME/dotfiles-sync.sh

./$HOME/dotfiles-install.sh
```

Using SOURCE or specific modules will update configs.


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

# AVOID single quote in install script
```

VERBOSE=...
/dev/stdout
/path/to/file

.dotfiles-modules/install.sh some-module or-another


# Testing

A Vagrant VM allows to easily tests changes to the config.

*Users*

- root:root
- vagrant:vagrant

Make sure to create the VM to install Gnome first, then reboot to launch install script.
```
vagrant up
vagrant reload && vagrant ssh -- '/home/vagrant/.dotfiles-modules/install.sh'
```

To disable VirtualBox's GUI set `DF_NO_UI` when creating the VM.
```
DF_NO_UI=1 vagrant up
# ...
```

First way to test is to run the install script from the Vagrant synced folder
```
vagrant ssh -- '/vagrant/.dotfiles-modules/install.sh'
```

Otherwise, to avoid resetting the VM entirely between iterations, use `vagrant reload --provision`, otherwise `vagrant destroy -f && vagrant up` will configure a new VM from scratch.

Testing uses local files when booting the VM, but it's also possible to validate the sync script from git using `DF_TEST_SYNC`

```
DF_TEST_SYNC=1 vagrant up --provision; vagrant ssh -- '/home/vagrant/.dotfiles-modules/install.sh'
```

## Complete fresh test command

```
vagrant destroy -f; vagrant up; vagrant reload; vagrant ssh -- '/home/vagrant/.dotfiles-modules/install.sh'
```

or using sync for git
```
DF_TEST_SYNC=1 vagrant destroy -f; vagrant up; vagrant reload; vagrant ssh -- '/home/vagrant/.dotfiles-modules/install.sh'
```

> Inspired from <https://www.atlassian.com/git/tutorials/dotfiles>
