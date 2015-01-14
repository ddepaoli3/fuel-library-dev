## This is class installed nagios NRPE
# ==Parameters
## proj_name => isolated configuration for project
## services  =>  array of services which you want use
## whitelist =>  array of IP addreses which NRPE trusts
## hostgroup =>  group wich will use in nagios master
# do not forget create it in nagios master
class nagios (
$services,
$servicegroups     = false,
$hostgroup         = false,
$proj_name         = 'nrpe.d',
$whitelist         = '127.0.0.1',
$nrpepkg           = $nagios::params::nrpepkg,
$nrpeservice       = $nagios::params::nrpeservice,
) inherits nagios::params  {

  $master_proj_name = "${proj_name}_master"

  case $::osfamily {
    'RedHat': {
      $basic_services = ['yum','kernel','libs','load','procs','zombie','swap','user','cpu','memory']   
    }
    'Debian': {
      $basic_services = ['procs','zombie','swap','user','load','memory']
    }
  }

  $services_ = concat($services,$basic_services)

  validate_array($services_)

}
