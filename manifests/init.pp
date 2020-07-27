# Requirements :
# - a certificate MUST be installed using puppet in /etc/grid-security/hostcert.pem (hostkey.pem)
# - the UMD4 repositories MUST be present
# 
# The PAP rules are specified in a hash this way :
# 
# argus::pap_rules:
# action:
# attribute:
# list of DNs
# 
# for instance (the included quotes are required for the policy to be correctly added ) :
# deny:
# subject-issuer:
# - "'CN=bad guys'"
# 
# will create a rule :
# rule deny { subject-issuer = 'CN=bad guys' }
class argus (
  #the argus pap server used by pdp
  $pap_server,
  #the argus pdp server used by pep
  $pdp_server,
  #the argus pep server (not used currently)
  $pep_server,

  $pkg_meta,
  $pkg_ensure,

  #this will setup the voms related things :
  $supported_vos,

  # site name is required
  $sitename,

  # shutdown secret pass
  $secret_pass,

  # pep params
  $pepd_port,
  $pepd_admin_port,

  # pdp params
  $pdps_port,
  $pdp_port,
  $pdp_admin_port,
  $pdp_retention_interval,

  # pap parameters
  $pap_port,
  $pap_shutdown_port,

  # central banning setup
  $centralbanning_dn,
  $centralbanning_hostname,
  $centralbanning_port,
  $centralbanning_public,
  $poll_interval,
  #files
  $grid_mapfile,
  $grid_mapdir,
  $group_mapfile,

  $open_firewall = false,
  #this will create argus "permit" rules for those VOs if true
  $supported_vos_allowed = true,

  $pepd_pass = randompass(),
  $pdp_pass = randompass(),
  $pap_shutdown_command = randompass(),

  $service_name      = $::fqdn ,

  #following must be changed.

  $pap_admin_dn      = undef , #this must be an *ARRAY* as there can be many admins.
  $site_base_dn      = '/O=GRID/C=FR_EN_UK/O=my CA/CN' , #a = will be apended to this when needed.


  $nfspath           = '' ,
  $nfsmountoptions   = '' ,
  $mountpoint        = '' ,

  # additional rules for pap authorization. Used for creating a NGI or central pap.
  # example :
  # pap_auth:
  #   policy:
  #     - DN1
  #
  # i.e :
  # pap_auth:
  #   POLICY_READ_LOCAL|POLICY_READ_REMOTE:
  #     - "/O=GRID-(...sites DN...)"
  #   POLICY_READ_LOCAL|POLICY_READ_REMOTE|CONFIGURATION_READ:
  #     - "/C=GR/O=HellasGrid/OU=afroditi.hellasgrid.gr/CN=srv-111.afroditi.hellasgrid.gr"
  #     - "/DC=org/DC=terena/DC=tcs/C=GR/ST=Attica/L=Athens/O=Greek Research and Technology Network/CN=secmon.egi.eu"
  $pap_auth          = {} ,

  # banning and permir rules
  # hash format is the following :
  #
  # hash_name :
  #   action (can be permit or deny - this is a hash) :
  #        attribute1 (subject, issuer, subject-issuer...):
  #             - DN1
  #             - DN2
  #        attibute2:
  # The hash is sorted because we will create the deny rules before the permit ones
  # ...

  $pap_rules         = {},
  ) {

  $pap_service_dn    = "${site_base_dn}=${service_name}"
  $pap_host_dn       = "${site_base_dn}=${::fqdn}"

  case $::osfamily {
    'RedHat' :   {
      #deps :
      include ::fetchcrl
      include ::epel
      include ::bdii

      include ::argus::install
      include ::argus::config
      include ::argus::service
      include ::argus::bdii
      Class['::epel'] -> Class['::argus::install'] -> Class['::argus::config'] -> Class['::argus::service']

      if($open_firewall) { include ::argus::firewall }

    }
    default: {
      # nothing here yet
    }
  }
}
