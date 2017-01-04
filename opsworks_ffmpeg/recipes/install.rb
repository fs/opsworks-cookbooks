log "[#{cookbook_name}][#{recipe_name}] Running ..."

node[:deploy].each do |app_name, deploy|
  execute "ppa:mc3man/trusty-media" do
    command "add-apt-repository ppa:mc3man/trusty-media"
  end

  execute "apt-get update" do
    action :run
  end

  package "ffmpeg" do
    action :install
  end
end

log "[#{cookbook_name}][#{recipe_name}] ... finished."
