include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  opsworks_nodejs do
    deploy_data deploy
    app application
  end

  application_environment_file do
    user deploy[:user]
    group deploy[:group]
    path ::File.join(deploy[:deploy_to], "shared")
    environment_variables deploy[:environment_variables]
  end

  bash "install_nodejs_via_nvm" do
    user "root"
    code <<-EOH
      curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash

      source ~/.nvm/nvm.sh

      nvm install 6.5.0
    EOH

    not_if do
      File.exist?("~/.nvm/nvm.sh")
    end
  end

  execute "change npm registry" do
    command "npm config set registry http://registry.npmjs.org/"
    action :run
  end

  bash "setup application locally" do
    cwd "#{deploy[:deploy_to]}/current"
    user "root"
    code <<-EOH
      source ~/.nvm/nvm.sh
      nvm use 6.5.0

      bin/setup
    EOH
  end

  ruby_block "restart node.js application #{application}" do
    block do
      Chef::Log.info("restart node.js via: #{node[:deploy][application][:nodejs][:restart_command]}")
      Chef::Log.info(`#{node[:deploy][application][:nodejs][:restart_command]}`)
      $? == 0
    end
  end
end
