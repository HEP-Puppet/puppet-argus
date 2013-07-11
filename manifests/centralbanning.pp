class argus::centralbanning inherits argus::params {
  
  if $centralbanning_enabled {
    concat::fragment{"pap_configuration.centralbanning.ini": 
      target  => "/usr/share/argus/pap/conf/pap_configuration.ini",
      order   => "1",
      content => template("argus/pap_configuration.ini.centralbanning.erb"),
    }
    file {"/etc/cron.d/centralbanning":
      ensure => present,
      owner => "root",
      group => "root",
      mode => 0644,
      content => template("argus/centralbanning.erb"),
    }
    exec {"/usr/bin/pap-admin --host $::fqdn enable-pap centralbanning && /usr/bin/pap-admin --host $::fqdn set-paps-order centralbanning default && /usr/bin/pap-admin --host $::fqdn refresh-cache centralbanning":
      require => File["/etc/cron.d/centralbanning"],
    }
  }
  else
  {
    concat::fragment{"pap_configuration.centralbanning.ini": 
      target  => "/usr/share/argus/pap/conf/pap_configuration.ini",
      order   => "1",
      content => template("argus/pap_configuration.ini.default.erb"),
    }
  }
}
  
