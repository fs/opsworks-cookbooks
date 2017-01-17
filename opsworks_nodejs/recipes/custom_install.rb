log "[#{cookbook_name}][#{recipe_name}] Running ..."

case node[:platform_family]
when "ubuntu","debian"
  execute "apt-get update" do
    action :run
  end

  %w(build-essential libssl-dev).each do |pkg|
    package pkg do
      action :install
    end
  end

  # script "install_nodejs_via_nvm" do
  #   interpreter "bash"
  #   user "ubuntu"
  #   code <<-EOH
  #     cd /home/ubuntu

  #     curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash

  #     echo "export NVM_DIR=\"/home/ubuntu/.nvm\"" >> /home/ubuntu/.bashrc
  #     echo "[ -s \"$NVM_DIR/nvm.sh\" ] && \. \"$NVM_DIR/nvm.sh\" >> /home/ubuntu/.bashrc

  #     source /home/ubuntu/.nvm/nvm.sh
  #     nvm install 6.5.0
  #   EOH
  # end

  execute "install nvm" do
    command "curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash"
    action :run
  end

  execute "activate nvm" do
    command ". ~/.nvm/nvm.sh"
    action :run
  end

  execute "install nodejs" do
    command "nvm install 6.5.0"
    action :run
  end
else
  raise "Your platform `#{node[:platform]}` (family: `#{node[:platform_family]}`) is not supported!"
end

log "[#{cookbook_name}][#{recipe_name}] ... finished."
