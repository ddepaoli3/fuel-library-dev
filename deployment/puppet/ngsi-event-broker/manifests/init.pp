class ngsi-event-broker (
  $region = "",
  $adapter = "http://127.0.0.1:1337"
)
{

  file { ["/usr/local/nagios", "/usr/local/nagios/lib"]:
    ensure => "directory",
  }

  file { "ngsi_event_broker_serv.so":
    source => "puppet:///modules/ngsi-event-broker/ngsi_event_broker_serv.so",
    path => "/usr/local/nagios/lib/ngsi_event_broker_serv.so",
    recurse => true,
    mode => 0755,
    require => File["/usr/local/nagios/lib"],
    }

  file_line { "/etc/nagios3/nagios.cfg":
    path => "/etc/nagios3/nagios.cfg",
    line => "broker_module=/usr/local/nagios/lib/ngsi_event_broker_serv.so -r '${region}' -u '${adapter}'",
    match   => "^#?broker_module=.* .*$",
    require => File["ngsi_event_broker_serv.so"],
    # notify  => Service["nagios"],  # Others will take care of the reload
  }

}
