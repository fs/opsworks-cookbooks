Chef::Log.info("Hello from ffmpeg_ubuntu::install")

node[:deploy].each do |app_name, deploy|

  Chef::Log.info("Hello from ffmpeg_ubuntu::install deploy")

  script "install_ffmpeg" do
    interpreter "bash"
    user "ubuntu"
    code <<-EOH

    sudo add-apt-repository ppa:jon-severinsson/ffmpeg
    sudo apt-get update
    sudo apt-get install ffmpeg

    EOH

    not_if do
      File.exist?("/usr/local/bin/ffmpeg")
    end
  end
end
