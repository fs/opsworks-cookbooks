
begin
  include_recipe "logrotate"

  logs = []
  node[:openvpn][:configs].each do |config_name,config|
    logs << "/var/log/openvpn/#{config_name}.log"
  end
  node[:openvpn][:client_configs].each do |config_name,config|
    logs << "/var/log/openvpn/#{config_name}.log"
  end

  logrotate_app "openvpn" do
    cookbook "logrotate"
    path logs
    options ["missingok", "compress", "copytruncate"]
    frequency "weekly"
    create "600 root root"
    rotate 4
  end
rescue
  Chef::Log.error "openvpn::logrotate requires the logrotate cookbook!"
end
