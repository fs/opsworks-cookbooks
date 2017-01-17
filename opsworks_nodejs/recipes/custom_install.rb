log "[#{cookbook_name}][#{recipe_name}] Running ..."

case node[:platform_family]
when "ubuntu","debian"
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
