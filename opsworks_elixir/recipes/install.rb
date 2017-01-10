log "[#{cookbook_name}][#{recipe_name}] Running ..."

case node[:platform_family]
when "ubuntu","debian"
  elixir_setup = node[:opsworks_elixir][:setup]
  esl_package  = "#{Chef::Config[:file_cache_path]}/#{elixir_setup[:package][:file]}"

  remote_file esl_package do
    source "#{elixir_setup[:package][:url]}#{elixir_setup[:package][:file]}"
    action :create_if_missing
  end

  package "erlang-solutions" do
    provider Chef::Provider::Package::Dpkg
    source   esl_package
    action   :install
  end

  execute "apt-get update" do
    action :run
  end

  elixir_setup[:install][:packages].each do |pkg|
    package pkg do
      action :install
    end
  end

  script "create_ssh_keys" do
    interpreter "bash"
    user "root"
    code <<-EOH

    ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''
    cat $HOME/.ssh/id_rsa.pub >> /home/ubuntu/.ssh/authorized_keys

    EOH
  end

  script "update_ssh_config" do
    interpreter "bash"
    user "root"
    code <<-EOH

    echo "Host ec2timelapse" >> $HOME/.ssh/config
    echo "Hostname localhost" >> $HOME/.ssh/config

    EOH
  end

  script "permit_opt_folder" do
    interpreter "bash"
    user "root"
    code <<-EOH

    chmod 777 /opt

    EOH
  end

  script "opsworks_env_vars" do
    interpreter "bash"
    user "root"
    code <<-EOH

    echo "if [ -f ~/.opsworks_env_vars ]; then" >> /home/ubuntu/.profile
    echo "  . ~/.opsworks_env_vars" >> /home/ubuntu/.profile
    echo "fi" >> /home/ubuntu/.profile

    EOH
  end
else
  raise "Your platform `#{node[:platform]}` (family: `#{node[:platform_family]}`) is not supported!"
end

log "[#{cookbook_name}][#{recipe_name}] ... finished."
