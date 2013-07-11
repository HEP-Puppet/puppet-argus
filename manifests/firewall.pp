class argus::firewall inherits argus::params{

  firewall { '101 allow argus pap':
    proto  => 'tcp',
    dport  => "$pap_port",
    action => 'accept',
  }
  firewall { '101 allow argus pdp':
    proto  => 'tcp',
    dport  => "$pdp_port",
    action => 'accept',
  }
  firewall { '101 allow argus pepd':
    proto  => 'tcp',
    dport  => "$pepd_port",
    action => 'accept',
  }
  include bdii::firewall
}
