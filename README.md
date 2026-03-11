# Requirements

- git

> Setup extracted from <https://www.atlassian.com/git/tutorials/dotfiles>

# Installation

```
wget -qO- https://raw.githubusercontent.com/thecodingjames/dotfiles/refs/heads/main/.dotfiles-scripts/sync.sh | bash

bash $HOME/.dotfiles-scripts/setup.sh
```

# Testing

To avoid resetting the VM entirely between iterations, use `vagrant reload --provision`, otherwise `vagrant destroy -f && vagrant up` will configure a new VM from scratch.

A Vagrant VM allows to easily tests changes to the config. To disable VirtualBox's GUI set `DF_NO_UI` when booting the VM.

```
DF_NO_UI=1 vagrant up
```

Testing uses local files when booting the VM, but it's also possible to validate the sync script from git using `DF_TEST_SYNC`

```
DF_TEST_SYNC DF_NO_UI=1 vagrant up
```

