class argus::rules_banning inherits argus::params  {

  file {'/var/cache/argus':
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0700',
    purge   => true,
    recurse => true,
  }

  file {'/var/cache/argus/policies_centralbanning.spl':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('argus/policies_centralbanning.erb'),
    require => File['/var/cache/argus'],
    notify  => Exec['update_argus_policies'],
  }

  exec {'delete_argus_policies':
    command => "/usr/bin/pap-admin --host ${::fqdn} remove-all-policies",
    onlyif  => '/usr/bin/test ! -s /var/cache/argus/policies_centralbanning.spl',
    notify  => Service['argus-pdp'] #restart the PDP service to take the new policies into account
  }

  exec {'update_argus_policies':
    command     => "/bin/cat /var/cache/argus/*.spl > /tmp/update$$.spl && /usr/bin/pap-admin --host ${::fqdn} remove-all-policies && /usr/bin/pap-admin --host ${::fqdn}  add-policies-from-file /tmp/update$$.spl && rm /tmp/update$$.spl",
    refreshonly => true,
    onlyif      => '/usr/bin/test -s /var/cache/argus/policies_centralbanning.spl',
    notify      => Service['argus-pdp'] #restart the PDP service to take the new policies into account
  }

  File['/var/cache/argus'] -> File['/var/cache/argus/policies_centralbanning.spl'] -> Exec['delete_argus_policies'] -> Exec['update_argus_policies']

}
