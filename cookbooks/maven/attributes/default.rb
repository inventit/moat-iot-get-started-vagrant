tarball = "apache-maven-3.0.4-bin.tar.gz"

set_unless[:maven][:installation_dir] = "/opt/maven"
set_unless[:maven][:dirname] = tarball[0..(tarball.rindex('-') - 1)]
set_unless[:maven][:tarball_url] = "http://www.us.apache.org/dist/maven/maven-3/3.0.4/binaries/#{tarball}"
set_unless[:maven][:tarball_checksum] = "e513740978238cb9e4d482103751f6b7"
set_unless[:maven][:tarball] = tarball
