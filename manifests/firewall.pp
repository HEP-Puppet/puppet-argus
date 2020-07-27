class argus::firewall {

  firewall { '101 allow argus pap':
    proto  => 'tcp',
    dport  => "$argus::pap_port",
    action => 'accept',
  }
  firewall { '101 allow argus pdp':
    proto  => 'tcp',
    dport  => "$argus::pdp_port",
    action => 'accept',
  }
  firewall { '101 allow argus pepd':
    proto  => 'tcp',
    dport  => "$argus::pepd_port",
    action => 'accept',
  }
  include bdii::firewall
}
