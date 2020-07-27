class argus::centralbanning  {

  if $::argus::centralbanning_hostname != '' {
    concat::fragment{'pap_configuration.centralbanning.ini':
      target  => '/usr/share/argus/pap/conf/pap_configuration.ini',
      order   => '1',
      content => template('argus/pap_configuration.ini.centralbanning.erb'),
    }
    file {'/etc/cron.d/centralbanning':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('argus/centralbanning.erb'),
    }

    ~> exec {"/usr/bin/pap-admin --host ${::fqdn} enable-pap centralbanning && /usr/bin/pap-admin --host ${::fqdn} set-paps-order centralbanning default && /usr/bin/pap-admin --host ${::fqdn} refresh-cache centralbanning":
      refreshonly => true,
      require     => Service['argus-pap']
    }
  }
  else
  {
    concat::fragment{'pap_configuration.centralbanning.ini':
      target  => '/usr/share/argus/pap/conf/pap_configuration.ini',
      order   => '1',
      content => template('argus/pap_configuration.ini.default.erb'),
    }
  }
}

