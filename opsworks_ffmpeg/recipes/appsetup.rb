Chef::Log.info('Hello from ffmpeg_ubuntu::appsetup')

Chef::Log.info('Hello from ffmpeg_ubuntu::appsetup deploy')

script "install_ffmpeg" do
  interpreter "bash"
  user "root"
  code <<-EOH
  sudo apt-get -y remove ffmpeg x264 libav-tools libvpx-dev libx264-dev
  sudo echo "deb http://www.freedesktop.org/software/gstreamer-sdk/data/packages/ubuntu/raring/amd64 ./" > /etc/apt/sources.list.d/gstreamer-sdk.list

  sudo wget -q -O - http://www.freedesktop.org/software/gstreamer-sdk/sdk.gpg | sudo apt-key add -

  sudo apt-get update
  sudo apt-get -y install build-essential checkinstall git libfaac-dev libgpac-dev \
     libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev librtmp-dev libtheora-dev \
     libvorbis-dev pkg-config texi2html yasm zlib1g-dev gstreamer-sdk-dev

  sudo apt-get -y install libx264-dev
  cd
  git clone --depth 1 git://git.videolan.org/x264
  cd x264
  ./configure --enable-static
  make
  sudo checkinstall --pkgname=x264 --pkgversion="3:$(./version.sh | \
     awk -F'[" ]' '/POINT/{print $4"+git"$5}')" --backup=no --deldoc=yes \
     --fstrans=no --default
  cd

  wget http://downloads.sourceforge.net/opencore-amr/fdk-aac-0.1.0.tar.gz
  tar xzvf fdk-aac-0.1.0.tar.gz
  cd fdk-aac-0.1.0
  ./configure
  make
  sudo checkinstall --pkgname=fdk-aac --pkgversion="0.1.0" --backup=no \
    --deldoc=yes --fstrans=no --default

  cd
  git clone --depth 1 https://chromium.googlesource.com/webm/libvpx 
  cd libvpx
  ./configure
  make
  sudo checkinstall --pkgname=libvpx --pkgversion="1:$(date +%Y%m%d%H%M)-git" --backup=no \
--deldoc=yes --fstrans=no --default

  cd ~/x264
  make distclean
  ./configure --enable-static
  make
  sudo checkinstall --pkgname=x264 --pkgversion="3:$(./version.sh | \
    awk -F'[" ]' '/POINT/{print $4"+git"$5}')" --backup=no --deldoc=yes \
    --fstrans=no --default

  cd
  git clone --depth 1 git://source.ffmpeg.org/ffmpeg
  cd ffmpeg
  ./configure --enable-gpl --enable-libfaac --enable-libmp3lame --enable-libopencore-amrnb \
    --enable-libopencore-amrwb --enable-librtmp --enable-libtheora --enable-libvorbis \
    --enable-libvpx --enable-libx264 --enable-nonfree --enable-version3 
  make
  sudo checkinstall --pkgname=ffmpeg --pkgversion="5:$(date +%Y%m%d%H%M)-git" --backup=no \
    --deldoc=yes --fstrans=no --default
    hash x264 ffmpeg

  EOH

  not_if do
    File.exist?("/usr/local/bin/ffmpeg")
  end
end
