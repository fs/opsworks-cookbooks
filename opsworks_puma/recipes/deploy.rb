application = node[:rails][:application_name]
deploy = node[:deploy][application]

opsworks_deploy_user do
  deploy_data deploy
end

opsworks_deploy_dir do
  user deploy[:user]
  group deploy[:group]
  path deploy[:deploy_to]
end

puma_web_app do
  application application
  deploy deploy
end if deploy[:puma]

service application do
  if node[:opsworks][:activity] == "deploy"
    action :restart
    restart_command "service #{application} restart"
  end
end
