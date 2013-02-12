tarball = "android-sdk_r21.0.1-linux.tgz"

set_unless[:android][:installation_dir] = "/opt/android"
set_unless[:android][:dirname] = "android-sdk-linux"
set_unless[:android][:tarball_url] = "http://dl.google.com/android/#{tarball}"
set_unless[:android][:tarball_checksum] = "eaa5a8d76d692d1d027f2bbcee019644"
set_unless[:android][:tarball] = tarball
