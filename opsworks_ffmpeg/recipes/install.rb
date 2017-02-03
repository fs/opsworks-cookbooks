log "[#{cookbook_name}][#{recipe_name}] Running ..."

case node[:platform_family]
when "ubuntu","debian"
  execute "ppa:mc3man/trusty-media" do
    command "add-apt-repository ppa:mc3man/trusty-media"
  end

  execute "apt-get update" do
    action :run
  end

  package "ffmpeg" do
    action :install
  end
else
  raise "Your platform `#{node[:platform]}` (family: `#{node[:platform_family]}`) is not supported!"
end

log "[#{cookbook_name}][#{recipe_name}] ... finished."
