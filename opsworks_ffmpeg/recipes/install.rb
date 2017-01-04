log "[#{cookbook_name}][#{recipe_name}] Running ..."

node[:deploy].each do |app_name, deploy|
  execute "ppa:jon-severinsson/ffmpeg" do
    command "add-apt-repository ppa:jon-severinsson/ffmpeg"
  end

  execute "apt-get update" do
    command "apt-get update"
    ignore_failure true
  end

  package "ffmpeg" do
    action :install
  end
end

log "[#{cookbook_name}][#{recipe_name}] ... finished."
