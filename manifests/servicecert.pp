class argus::servicecert inherits argus::params {
  if $service_name == $::fqnd {
    # we can use the puppet autogenerated certificate
    class {'hostcertificate::gridcertificate':}
  }
  else
  {
    if !defined(File['/etc/grid-security']) {
      file {'/etc/grid-security':
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0700',
      }
    }
  }
}

