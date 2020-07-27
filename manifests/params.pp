class argus::params {
  # site name 
  $sitename        = hiera('SITENAME','SOME.WHERE')

  # pep params
  $pepd_port       = hiera('PEPD_DEFAULT_PORT', '8154')
  $pepd_admin_port = hiera('PEPD_DEFAULT_ADMIN_PORT', '8155')
  $pepd_pass       = hiera('PEPD_DEFAULT_PASS', randompass() )

  # pdp params
  $pdps_port       = hiera('PDPS_PORT', '8152')
  $pdp_port        = hiera('PDP_DEFAULT_PORT', '8152')
  $pdp_admin_port  = hiera('PDP_DEFAULT_ADMIN_PORT', '8153')
  $pdp_pass        = hiera('PDP_DEFAULT_PASS', randompass() )

  # pap parameters
  $pap_port        = hiera('PAP_DEFAULT_PORT', '8150')
  $pap_shutdown_port = hiera('PAP_DEFAULT_SHUTDOWN_PORT', '8151')
  $pap_shutdown_command = hiera('PAP_DEFAULT_SHUTDOWN_COMMAND', randompass() )


  # central banning setup  
  $centralbanning_enabled  = hiera('CENTRALBANNING_ENABLED','false')
  $centralbanning_dn       = hiera('CENTRALBANNING_DN', '')
  $centralbanning_hostname = hiera('CENTRALBANNING_HOSTNAME', '')
  $centralbanning_port     = hiera('CENTRALBANNING_PORT', 8150)
  $poll_interval           = hiera('POLL_INTERVAL', 14400)

  $service_name     = hiera('SERVICE_NAME', $::fqdn)
  $pap_admin_dn     = hiera('PAP_ADMIN_DN', '')
  $site_base_dn     = hiera('SITE_BASE_DN', '')
  $pap_service_dn   = hiera('PAP_SERVICE_DN', "${site_base_dn}=${service_name}")
  $pap_host_dn      = hiera('PAP_HOST_DN', "${site_base_dn}=${::fqdn}")
  $nfspath          = hiera('NFSPATH', '')
  $nfsmountoptions  = hiera('NFSMOUNTOPTIONS', '')
  $mountpoint       = hiera('MOUNTPOINT', '')

  # additional rules for pap
  $pap_auth         = hiera('PAP_AUTH','')

  # banning rules
  $pap_ban          = hiera('PAP_BAN','')

}
