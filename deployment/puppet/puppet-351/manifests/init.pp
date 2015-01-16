class puppet-351 {

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
    source => "puppet:///modules/puppet-351/packages/",
    require => File["base_dir_install_puppet"],
  }

  file { "script_install_puppet":
    source => "puppet:///modules/puppet-351/install_puppet-3.5.1",
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

  # This will not work, we need to update the main part of the conf
  # While waiting for the bug to be solved we use the ini settings
  # https://tickets.puppetlabs.com/browse/PDB-1120?jql=project%20%3D%20PDB

  class { 'puppetdb::master::config':
    puppetdb_server => '10.20.0.2',  # TODO: no dns/host configured on nodes?
    puppetdb_port   =>  58443,
    restart_puppet  =>  false,  # the default true trows an error:
                                # Could not find init script or upstart
                                # conf file for 'puppetmaster'
    require => Exec["exec_install_puppet"],
  }

  ini_setting { "workaround for PDB-1120 part 1/2":
    ensure  => present,
    path    => '/etc/puppet/puppet.conf',
    section => 'main',
    setting => 'storeconfigs_backend',
    value   => 'puppetdb',
    require => Exec["exec_install_puppet"],
  }

  ini_setting { "workaround for PDB-1120 part 2/2":
    ensure  => present,
    path    => '/etc/puppet/puppet.conf',
    section => 'main',
    setting => 'storeconfigs',
    value   => 'true',
    require => Exec["exec_install_puppet"],
  }

}
