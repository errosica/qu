yumrepo { "mongodb":
  name => 'mongodb',
  baseurl => 'http://downloads-distro.mongodb.org/repo/redhat/os/$basearch/',
  gpgcheck => 0,
  enabled => 1,
}

yumrepo { 'epel':
  name => 'EPEL',
  mirrorlist => 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch',
  gpgcheck => 0,  
  enabled => 1,
}

package { "mongodb-org":
  ensure => present,
  require => Yumrepo["mongodb"],
}

service { "mongod":
  ensure => running,
  require => Package["mongodb-org"],
}

package { "nodejs":
  ensure => present,
  require => Yumrepo["epel"]
}

package { "npm":
  ensure => present,
  require => [Yumrepo["epel"], Package["nodejs"]],
}

package { "git":
  ensure => present,
}

package { "java-1.7.0-openjdk":
  ensure => present,
}

exec { 'install leiningen':
  command => "/usr/bin/curl -sL https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein > /usr/bin/lein",
  creates => "/usr/bin/lein",
}

file { "/usr/bin/lein":
  ensure => present,
  mode => "0755",
  owner => "root",
  require => Exec["install leiningen"],
}

exec { 'install bower':
  command => "/usr/bin/npm install -g bower",
  creates => "/usr/bin/bower",
  require => Package["npm"],
}

exec { 'install grunt':
  command => "/usr/bin/npm install -g grunt-cli",
  creates => "/usr/bin/grunt",
  require => Package["npm"],
}

service { "iptables":
  ensure => "stopped"
}
