log "[#{cookbook_name}][#{recipe_name}] Running ..."

case node[:platform_family]
when "ubuntu","debian"
  elixir_setup = node[:opsworks_elixir][:setup]
  esl_package  = "#{Chef::Config[:file_cache_path]}/#{elixir_setup[:package][:file]}"

  remote_file esl_package do
    source "#{elixir_setup[:package][:url]}#{elixir_setup[:package][:file]}"
    action :create_if_missing
  end

  package "erlang-solutions" do
    provider Chef::Provider::Package::Dpkg
    source   esl_package
    action   :install
  end

  execute "apt-get update" do
    action :run
  end

  elixir_setup[:install][:packages].each do |pkg|
    package pkg do
      action :install
    end
  end
else
  raise "Your platform `#{node[:platform]}` (family: `#{node[:platform_family]}`) is not supported!"
end

log "[#{cookbook_name}][#{recipe_name}] ... finished."
