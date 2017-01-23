log "[#{cookbook_name}][#{recipe_name}] Running ..."

case node[:platform_family]
when "ubuntu","debian"
  Chef::Log.info("Install nodejs from source")
  execute "Add nodejs to apt source" do
    command "curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -"
    action :run
  end

  execute "Install nodejs via apt-get" do
    command "sudo apt-get install -y nodejs"
    action :run
  end

  Chef::Log.info("Make a symlink for new version of nodejs")
  execute "Symlink new nodejs" do
    command "ln -s /usr/bin/nodejs /usr/local/bin/node"
    action :run

    not_if do
      File.exist?("/usr/local/bin/node")
    end
  end
else
  raise "Your platform `#{node[:platform]}` (family: `#{node[:platform_family]}`) is not supported!"
end

log "[#{cookbook_name}][#{recipe_name}] ... finished."
