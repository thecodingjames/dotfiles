Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"

  config.vm.box_check_update = true

  config.vm.provider "virtualbox" do |vb|
    DF_NO_UI = ENV["DF_NO_UI"]
    vb.gui = DF_NO_UI ? false : true
  
    vb.cpus = "4"
    vb.memory = "4096"
    vb.customize ["modifyvm", :id, "--vram", "128"]
  end
  
  config.vm.provision "shell", inline: <<-AS_ROOT
    echo "root:root" | chpasswd
    echo "vagrant:vagrant" | chpasswd

    sed -i s/"1"/"0"/g /etc/apt/apt.conf.d/20auto-upgrades

    export DEBIAN_FRONTEND=noninteractive
    export NEEDRESTART_MODE=a

    apt-get update
    apt-get -y upgrade

    apt-get autoclean
    apt-get -y autoremove

    apt-get install -q -y \
      gnome \
      git

    cat <<-'AUTO_LOGIN' >> /etc/gdm3/daemon.conf
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=vagrant
AUTO_LOGIN
  AS_ROOT

  #
  # Upgrade DEBIAN
  #
  # run: "never" | "always"
  # to control whether to update debian, usefull to test using debian 12
  # 
  config.vm.provision "shell", run: "always", inline: <<-AS_ROOT
    export DEBIAN_FRONTEND=noninteractive
    export NEEDRESTART_MODE=a

    apt-get update
    apt-get -y upgrade
    apt-get -y dist-upgrade

    apt-get autoclean
    apt-get -y autoremove

    apt-get --fix-broken -y install

    sed -i 's/bookworm/trixie/g' /etc/apt/sources.list

    apt-get update
    apt-get -y upgrade
    apt-get -y full-upgrade

    apt-get autoclean
    apt-get -y autoremove

    apt-get update
    apt-get -y upgrade
    apt-get -y dist-upgrade
  AS_ROOT

  DF_TEST_SYNC = ENV["DF_TEST_SYNC"]

  source_message = DF_TEST_SYNC ? "SYNC from git" : "COPY from /vagrant"
  source_command = if DF_TEST_SYNC
    "/vagrant/.dotfiles-sync.sh"
  else
    # eval hacky hack to have glob options enabled
    # otherwise the whole command is parsed at once and invalid until glob is enabled
    "shopt -s dotglob extglob && eval 'cp -a /vagrant/!(.git) /home/vagrant/'"
  end

  config.vm.provision "shell", inline: <<-SYNC
    echo 'Running #{source_message}'

    su vagrant -lc 'shopt -s dotglob extglob'
    su vagrant -lc "#{source_command}" # Deliberate ", to wrap single-quote from source_command
  SYNC
end
