include_recipe "deploy"

node[:deploy].each do |application, deploy|
  script "update_ssh_config" do
    interpreter "bash"
    user "ubuntu"
    code <<-EOH

    echo "Host ec2timelapse" > /home/ubuntu/.ssh/config
    echo "Hostname localhost" > /home/ubuntu/.ssh/config
    echo "User ubuntu" > /home/ubuntu/.ssh/config

    EOH
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  execute "get local hex" do
    command "mix local.hex --force"
    action :run
  end

  before_migrate do
    cwd release_path
  end

  execute "setup application locally" do
    command "bin/setup"
    action :run
  end

  execute "deploy with edeliver" do
    command "bin/deploy staging"
    action :run
  end
end
