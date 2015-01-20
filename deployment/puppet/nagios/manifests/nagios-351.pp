class nagios::nagios-351 {

  # TODO: check for better check: for having only one execution

  file { "base_dir_install_nagios":
    path => "/var/tmp/nagios-install/",
    ensure => "directory",
    owner  => "root",
    group  => "root",
    recurse => "true",
    mode   => "0750",
  }

  file { "dir_install_nagios":
    path => "/var/tmp/nagios-install/packages",
    ensure => "directory",
    owner  => "root",
    group  => "root",
    recurse => "true",
    mode   => "0750",
    source => "puppet:///modules/nagios/packages/",
    require => File["base_dir_install_nagios"],
  }

  file { "script_install_nagios":
    source => "puppet:///modules/nagios/install_nagios-3.5.1",
    path => "/var/tmp/nagios-install/install_nagios-3.5.1",
    mode => 0700,
    require => File["dir_install_nagios"],
  }

  exec { "exec_install_nagios":
    path => "/usr/bin:/usr/sbin:/bin:/sbin",
    cwd => "/var/tmp/nagios-install",
    command => "/var/tmp/nagios-install/install_nagios-3.5.1",
    onlyif => '/usr/bin/test ! -e /etc/nagios3/nagios-3.5.1.flag',
    require => File["script_install_nagios"],
  }

}
