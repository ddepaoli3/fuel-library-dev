class install-puppet-3.5.1 {

  file { "base_dir_install_puppet":
    path => "/var/tmp/puppet-install/",
    ensure => "directory",
    owner  => "root",
    group  => "root",
    recurse => "true",
    mode   => "0750",
  }

  file { "dir_install_puppet":
    path => "/var/tmp/puppet-install/packages",
    ensure => "directory",
    owner  => "root",
    group  => "root",
    recurse => "true",
    mode   => "0750",
    source => "puppet:///modules/puppet-3.5.1/packages/",
    require => File["base_dir_install_puppet"],
  }

  file { "script_install_puppet":
    source => "puppet:///modules/puppet-3.5.1/install_puppet-3.5.1",
    path => "/var/tmp/puppet-install/install_puppet-3.5.1",
    mode => 0700,
    require => File["dir_install_puppet"],
  }

  exec { "exec_install_puppet":
    path => "/usr/bin:/usr/sbin:/bin:/sbin",
    cwd => "/var/tmp/puppet-install",
    command => "/var/tmp/puppet-install/install_puppet-3.5.1",
    require => File["script_install_puppet"],
  }

}
