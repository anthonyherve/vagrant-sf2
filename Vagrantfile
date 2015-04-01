dir = File.dirname(File.expand_path(__FILE__))

require 'yaml'
CONF = YAML.load_file("#{dir}/config/config.yaml")

Vagrant.configure(2) do |config|
  # Core configurations
  # -------------------
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory", 1024]
    v.customize ["modifyvm", :id, "--cpus", 2]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--name", "perso"]
  end

  # Running bootstrap
  # -----------------
  config.vm.provision 'shell' do |s|
      s.path = "shell/init.sh"
      s.args = ["#{CONF['database']['pwd']}"]
    end
  CONF['websites'].each do |i, website|
      config.vm.provision 'shell' do |s|
        s.path = "shell/bootstrap.sh"
        s.args = ["#{website['name']}", "#{website['url']}", "#{CONF['database']['pwd']}", "#{CONF['private_network']}"]
      end
  end

  # Forwarding ports
  # ----------------
  config.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", disabled: "true"
  config.vm.network :forwarded_port, guest: 22, host: "#{CONF['ports']['ssh']}"
  config.vm.network :forwarded_port, guest: 80, host: "#{CONF['ports']['http']}"

  # IP Static
  # ---------
  config.vm.network "private_network", ip: "#{CONF['private_network']}"

  # Synced folders
  # --------------
  CONF['websites'].each do |i, website|
    config.vm.synced_folder "#{website['sync_folder']}", "/var/www/#{website['name']}", type: "nfs"
  end
end
