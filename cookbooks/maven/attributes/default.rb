tarball = "apache-maven-3.0.5-bin.tar.gz"

set_unless[:maven][:installation_dir] = "/opt/maven"
set_unless[:maven][:dirname] = tarball[0..(tarball.rindex('-') - 1)]
set_unless[:maven][:tarball_url] = "http://www.us.apache.org/dist/maven/maven-3/3.0.5/binaries/#{tarball}"
set_unless[:maven][:tarball_checksum] = "94c51f0dd139b4b8549204d0605a5859"
set_unless[:maven][:tarball] = tarball
