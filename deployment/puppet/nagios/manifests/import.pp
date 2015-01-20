# TODO: inherits will also import facter stuff like: $::fuel_settings?

class nagios::import inherits nagios::master {
  tag 'nagios', 'nagios-import'

  $deployment_id = $::fuel_settings['deployment_id']
  $tag = "deployment_${deployment_id}"

  notify{ "**** importing host with tag ${tag} *****": }

  Nagios_host <<|tag==$tag|>> {
    notify  => Exec['fix-permissions'],
    require => File["/etc/${masterdir}/${master_proj_name}"],
  }
}
