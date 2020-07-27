class argus::config {

  # VOMS
  #we need the VOMS mappings, use vosupport module
  class {'vosupport':
    supported_vos               => $argus::supported_vos ,
    enable_mappings_for_service => 'ALL',
    enable_poolaccounts         => false,
    enable_environment          => false,
    enable_voms                 => false,
    enable_gridmapdir_for_group => 'root',
  }

  #include voms servers information
  #and make sure the VO names do not contain a puppet invalid char for the names, replace it with an underscore.
  $vo_classes=regsubst(($argus::supported_vos),'[\-\.]','_','G')
  ::argus::voms { $vo_classes :}

  #
  # configuration files and directories
  #

  file {['/etc/argus', '/etc/argus/info-glue2' ]:
    ensure => directory,
    owner  => 0,
    group  => 0,
    mode   => '0755',
  }

  concat{'/usr/share/argus/pap/conf/pap_configuration.ini':
    owner   =>  'root',
    group   =>  'root',
    mode    =>  '0640',
    require => Package[$argus::pkg_meta],
    notify  => Service['argus-pap'],
  }


  concat::fragment{'pap_configuration.ini':
    target  => '/usr/share/argus/pap/conf/pap_configuration.ini',
    order   => '9',
    content => template('argus/pap_configuration.ini.erb'),
  }



  file {'/usr/share/argus/pap/conf/pap_authorization.ini':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('argus/pap_authorization.ini.erb'),
    require => Package[$argus::pkg_meta],
    notify  => Service['argus-pap'],
  }

  file {'/usr/share/argus/pap/conf/pap-admin.properties':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('argus/pap-admin.properties.erb'),
    require => Package[$argus::pkg_meta],
    notify  => Service['argus-pap'],
  }

  file {'/etc/argus/pdp/pdp.ini':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('argus/pdp.ini.erb'),
    require => Package[$argus::pkg_meta],
    notify  => Service['argus-pdp'],
  }

  file {'/usr/share/argus/pepd/conf/pepd.ini':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('argus/pepd.ini.erb'),
    require => Package[$argus::pkg_meta],
    notify  => Service['argus-pepd'],
  }

  include 'argus::centralbanning'




  #pepd service must be restarted when the gridmap files change
  File[
    '/etc/grid-security/grid-mapfile',
    '/etc/grid-security/voms-grid-mapfile',
    '/etc/grid-security/groupmapfile'
  ]~>Service['argus-pepd']

  File[
    '/usr/share/argus/pap/conf/pap_authorization.ini',
    '/usr/share/argus/pap/conf/pap-admin.properties',
    '/etc/argus/pdp/pdp.ini',
    '/usr/share/argus/pepd/conf/pepd.ini'
  ] -> Class['vosupport'] -> Class['argus::bdii']

}
