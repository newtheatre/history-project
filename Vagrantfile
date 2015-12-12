$provision = <<SCRIPT
sudo apt-add-repository ppa:brightbox/ruby-ng
sudo apt-get update && sudo apt-get -y install build-essential git
sudo apt-get -y install nodejs npm imagemagick ruby2.2 ruby2.2-dev

# Generate locales, fixes bug where Vagrant VM breaks on some UTF-8
sudo locale-gen en_GB en_GB.UTF-8
sudo dpkg-reconfigure locales

# http://stackoverflow.com/a/1892889/2126990
# priority ruby: https://gist.github.com/brodock/7693207
sudo update-alternatives --remove ruby /usr/bin/ruby2.2
sudo update-alternatives --remove irb /usr/bin/irb2.2
sudo update-alternatives --remove gem /usr/bin/gem2.2

sudo update-alternatives \
    --install /usr/bin/ruby ruby /usr/bin/ruby2.2 50 \
    --slave /usr/bin/irb irb /usr/bin/irb2.2 \
    --slave /usr/bin/rake rake /usr/bin/rake2.2 \
    --slave /usr/bin/gem gem /usr/bin/gem2.2 \
    --slave /usr/bin/rdoc rdoc /usr/bin/rdoc2.2 \
    --slave /usr/bin/testrb testrb /usr/bin/testrb2.2 \
    --slave /usr/bin/erb erb /usr/bin/erb2.2 \
    --slave /usr/bin/ri ri /usr/bin/ri2.2

update-alternatives --config ruby
update-alternatives --display ruby

sudo gem install bundler
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo npm install -g coffee-script bower

cd /vagrant
bundle install
npm install
bower install --allow-root
SCRIPT

Vagrant::Config.run do |config|

  config.vm.box = "ubuntu/trusty64"
  config.vm.forward_port 8000, 8000
  config.vm.provision :shell, inline: $provision

  config.ssh.forward_agent = true
end
