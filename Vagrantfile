Vagrant.configure("2") do |config|
  config.vm.box = "debian/testing64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Disable the default share of the current code directory. Doing this
  # provides improved isolation between the vagrant box and your host
  # by making sure your Vagrantfile isn't accessible to the vagrant box.
  # If you use this you may want to enable additional shared subfolders as
  # shown above.
  # config.vm.synced_folder ".", "/vagrant", disabled: true

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
    apt-get upgrade -y

    apt-get install -q -y \
      gnome \
      git

    cat <<-'AUTO_LOGIN' >> /etc/gdm3/daemon.conf
    [daemon]
    AutomaticLoginEnable=True
    AutomaticLogin=vagrant
AUTO_LOGIN
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

  config.vm.provision "shell", inline: <<-TEST_SOURCE
    echo 'Running #{source_message}'
    su vagrant -lc 'shopt -s dotglob extglob'
    su vagrant -lc "#{source_command}" # Deliberate ", to wrap single-quote from source_command
  TEST_SOURCE
end
