class argus::config inherits argus::params {
  
  #
  # configuration files
  #
  include concat::setup

  concat{"/usr/share/argus/pap/conf/pap_configuration.ini":
    owner =>  'root',
    group =>  'root',
    mode  =>  '0640',
    require => Package['emi-argus'],
    notify  => Service['argus-pap'],
  }
  
     
  concat::fragment{"pap_configuration.ini": 
    target  => "/usr/share/argus/pap/conf/pap_configuration.ini",
    order   => "9",
    content => template("argus/pap_configuration.ini.erb"),
  }
  

  
  file {"/usr/share/argus/pap/conf/pap_authorization.ini":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0640,
    content => template("argus/pap_authorization.ini.erb"),
    require => Package['emi-argus'],
    notify  => Service['argus-pap'],
  }
  
  file {"/usr/share/argus/pap/conf/pap-admin.properties":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    content => template("argus/pap-admin.properties.erb"),
    require => Package['emi-argus'],
    notify  => Service['argus-pap'],
  }
  
  file {"/etc/argus/pdp/pdp.ini":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0640,
    content => template("argus/pdp.ini.erb"),
    require => Package['emi-argus'],
    notify  => Service['argus-pdp'],
  }
  
  file {"/usr/share/argus/pepd/conf/pepd.ini":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0640,
    content => template("argus/pepd.ini.erb"),
    require => Package['emi-argus'],
    notify  => Service['argus-pepd'],
  }
  
  include 'argus::centralbanning'
  
  class {'vosupport':
    supported_vos => [atlas, cms, lhcb, alice, dteam, ops, 'vo.aleph.cern.ch', 'vo.delphi.cern.ch', 'vo.l3.cern.ch', 
                      'vo.opal.cern.ch', ilc, 'envirogrids.vo.eu-egee.org', geant4, na48, unosat, 'vo.gear.cern.ch',
                      'vo.sixt.cern.ch'], #prod.vo.eu-eela.eu: missing voms
    enable_mappings_for_service => 'ARGUS',
    enable_poolaccounts => false,
    enable_environment => false,
    enable_voms => true,
    enable_gridmapdir_for_group => "root",
  }
  
  
  #pepd service must be restarted when the gridmap files change
  File['/etc/grid-security/grid-mapfile','/etc/grid-security/voms-grid-mapfile','/etc/grid-security/groupmapfile']~>Service['argus-pepd']
  
  File['/usr/share/argus/pap/conf/pap_authorization.ini','/usr/share/argus/pap/conf/pap-admin.properties','/etc/argus/pdp/pdp.ini','/usr/share/argus/pepd/conf/pepd.ini'] -> Class['vosupport'] -> Class['argus::bdii']
  
}
