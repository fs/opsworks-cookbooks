# Accepts:
#   application (application name)
#   deploy (hash of deploy attributes)
#   env (hash of custom environment settings)

define :custom_env_template do
  template "#{params[:deploy][:deploy_to]}/shared/config/.env" do
    source ".env.erb"
    owner params[:deploy][:user]
    group params[:deploy][:group]
    mode "0660"
    variables :env => params[:env]

    only_if do
      File.exists?("#{params[:deploy][:deploy_to]}/shared/config")
    end
  end
end
