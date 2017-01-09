include_recipe "deploy"

node[:deploy].each do |application, deploy|
  opsworks_deploy do
    deploy_data deploy
    app application
  end

  execute "get local hex" do
    command "mix local.hex --force"
    action :run
  end

  execute "get local rebar" do
    command "mix local.rebar --force"
    action :run
  end

  execute "setup application locally" do
    cwd "#{deploy[:deploy_to]}/current"
    command "bin/setup"
    action :run
  end

  execute "deploy with edeliver" do
    cwd "#{deploy[:deploy_to]}/current"
    command "bin/deploy staging"
    action :run
  end
end
