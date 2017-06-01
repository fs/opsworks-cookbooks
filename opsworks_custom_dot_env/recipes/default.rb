# Recipe used for a setup and deploy events
Chef::Log.info("Create .env file...")

application = node[:rails][:application_name]
deploy = node[:deploy][application]

environment_variables = deploy[:custom_env].to_h.merge(deploy[:environment_variables].to_h)

custom_env_template do
  application application
  deploy deploy
  env environment_variables
end
