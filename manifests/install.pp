class argus::install {
  package { $::argus::pkg_meta :
    ensure => $::argus::pkg_ensure,
    tag => 'argus',
  }
}
