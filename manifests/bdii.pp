class argus::bdii {
  #
  # setup the service provider for bdii on Argus
  #
  include ::bdii

  file {"/var/lib/bdii/gip/provider/glite-info-glue2-provider-service-argus":
    ensure => file,
    owner => "ldap",
    group => "ldap",
    mode => '0755',
    content => template("argus/glite-info-glue2-provider-service-argus.erb"),
    require => Package['bdii'],
  }

  file {"/etc/argus/info-glue2/glite-info-glue2-argus-pep.conf":
    ensure => file,
    owner => "root",
    group => "root",
    mode => '0644',
    force => true,
    content => template("argus/glite-info-glue2-argus-pep.conf.erb"),
  }

  file {"/etc/argus/info-glue2/glite-info-glue2-argus-pdp.conf":
    ensure => file,
    owner => "root",
    group => "root",
    mode => '0644',
    force => true,
    content => template("argus/glite-info-glue2-argus-pdp.conf.erb"),
  }

  file {"/etc/argus/info-glue2/glite-info-glue2-argus-pap.conf":
    ensure => file,
    owner => "root",
    group => "root",
    mode => '0644',
    force => true,
    content => template("argus/glite-info-glue2-argus-pap.conf.erb"),
  }



}
