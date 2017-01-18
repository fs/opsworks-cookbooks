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

  script "install_nodejs_via_nvm" do
    interpreter "bash"
    user "deploy"
    cwd "/home/deploy"
    environment "HOME" => "/home/deploy"
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

  execute "setup application locally" do
    cwd "#{deploy[:deploy_to]}/current"
    command "nvm use 6.5.0 && bin/setup"
    action :run
  end

  application_environment_file do
    user deploy[:user]
    group deploy[:group]
    path ::File.join(deploy[:deploy_to], "shared")
    environment_variables deploy[:environment_variables]
  end

  ruby_block "restart node.js application #{application}" do
    block do
      Chef::Log.info("restart node.js via: #{node[:deploy][application][:nodejs][:restart_command]}")
      Chef::Log.info(`#{node[:deploy][application][:nodejs][:restart_command]}`)
      $? == 0
    end
  end
end
