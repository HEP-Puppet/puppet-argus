class argus::bdii inherits argus::params {
  #
  # setup the service provider for bdii on Argus
  # 
  include bdii
  file {"/var/lib/bdii/gip/provider/glite-info-glue2-provider-service-argus":
    ensure => present,
    owner => "ldap",
    group => "ldap",
    mode => 0755,
    content => template("argus/glite-info-glue2-provider-service-argus.erb"),
    require => Package['emi-argus'],
  }
  
  #
  file {"/etc/glite/info/service/glite-info-glue2-argus-pep.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    content => template("argus/glite-info-glue2-argus-pep.conf.erb"),
    require => Package['emi-argus'],
  }
  
  file {"/etc/glite/info/service/glite-info-glue2-argus-pdp.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    content => template("argus/glite-info-glue2-argus-pdp.conf.erb"),
    require => Package['emi-argus'],
  }
  
  file {"/etc/glite/info/service/glite-info-glue2-argus-pap.conf":
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0644,
    content => template("argus/glite-info-glue2-argus-pap.conf.erb"),
    require => Package['emi-argus'],
  }
  

  
}
