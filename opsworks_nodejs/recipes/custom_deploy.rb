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

  Chef::Log.info("Install nodejs from source")
  execute "Add nodejs to apt source" do
    command "curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -"
    action :run
  end

  execute "Install nodejs via apt-get" do
    command "sudo apt-get install -y nodejs"
    action :run
  end

  Chef::Log.info("Local application setup via bin/setup")
  execute "bin/setup" do
    cwd "#{deploy[:deploy_to]}/current"
  end

  # ruby_block "change HOME to #{deploy[:home]} for local setup" do
  #   block do
  #     ENV['HOME'] = "#{deploy[:home]}"
  #   end
  # end

  # Chef::Log.info("Install nvm from source")
  # execute "Install nvm" do
  #   command "curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash"
  #   action :run

  #   not_if do
  #     File.exist?("~/.nvm/nvm.sh")
  #   end
  # end

  # Chef::Log.info("Install nodejs 6.5.0 via nvm")
  # execute ". ~/.nvm/nvm.sh && nvm install 6.5.0 && nvm alias default node" do
  # end

  # Chef::Log.info("Local application setup via bin/setup")
  # execute ". ~/.nvm/nvm.sh && npm --prefix="" set prefix "" && nvm use --delete-prefix v6.5.0 --silent && bin/setup" do
  #   cwd "#{deploy[:deploy_to]}/current"
  # end

  # ruby_block "change HOME back to /root after local setup" do
  #   block do
  #     ENV['HOME'] = "/root"
  #   end
  # end

  ruby_block "restart node.js application #{application}" do
    block do
      Chef::Log.info("restart node.js via: #{node[:deploy][application][:nodejs][:restart_command]}")
      Chef::Log.info(`#{node[:deploy][application][:nodejs][:restart_command]}`)
      $? == 0
    end
  end
end
