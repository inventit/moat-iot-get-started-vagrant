tarball = "android-sdk_r21.0.1-linux.tgz"
installation_dir = "/opt/android"
dirname = "android-sdk-linux"

set_unless[:android][:installation_dir] = installation_dir
set_unless[:android][:dirname] = dirname
set_unless[:android][:tarball_url] = "http://dl.google.com/android/#{tarball}"
set_unless[:android][:tarball_checksum] = "eaa5a8d76d692d1d027f2bbcee019644"
set_unless[:android][:tarball] = tarball

platform_tarball = "android-16_r04.zip"
set_unless[:android][:platform_dir] = "#{installation_dir}/#{dirname}/platforms"
set_unless[:android][:platform_url] = "http://dl.google.com/android/repository/#{platform_tarball}"
set_unless[:android][:platform_tarball_checksum] = "90b9157b8b45f966be97e11a22fba4591b96c2ee"
set_unless[:android][:platform_tarball] = platform_tarball
