class argus::policies {

  file {"/var/cache/argus":
    ensure => directory,
    owner => root,
    group => root,
    mode => '0700',
    purge => true,
    recurse => true,
  }

  file {"/var/cache/argus/policies.spl":
    ensure => present,
    owner => "root",
    group => "root",
    mode => '0644',
    content => template("argus/policies.erb"),
    require => File["/var/cache/argus"],
    notify => Exec["update_argus_policies"],
  }

  exec {"delete_argus_policies":
    command => "/usr/bin/pap-admin --host $::fqdn remove-all-policies",
    onlyif => "/usr/bin/test ! -s /var/cache/argus/policies.spl",
    notify => Exec['update_pdp_rules']
  }


  $pap_update_cmd = "/bin/cat /var/cache/argus/*.spl > /tmp/update$$.spl && /usr/bin/pap-admin --host $::fqdn remove-all-policies && /usr/bin/pap-admin --host $::fqdn  add-policies-from-file /tmp/update$$.spl && rm /tmp/update$$.spl"

  exec {"update_argus_policies":
    command => "$pap_update_cmd  || { rm -f /var/cache/argus/policies.spl ; pkill -f 'java.*argus/pap' ;}",
    refreshonly => true,
    onlyif => "/usr/bin/test -s /var/cache/argus/policies.spl",
    notify => Exec['update_pdp_rules'],
    require => Service['argus-pap']
  }

  #a new exec whose only goal is to try to reload policies if none is found in argus AND the policies.spl file is not empty. Meaning the policies are not there but should !
  # this can happen on reinstall, and this can then cause Undetermined decisions in pdp/pep, causing sites breakdown
  #remove policies.spl on failure, to trigger a new argus pap config on next run
  #kill argus pap on failure too as a "pdp reloadpolicy" just doesn't complain if policies are empty !
  exec {"update_argus_policies_on_previous_failure":
    command => "$pap_update_cmd  || { rm -f /var/cache/argus/policies.spl ; pkill -f 'java.*argus/pap' ;}",
    onlyif => "/bin/bash -c '(pap-admin lp | grep -q \"No policies\") && /usr/bin/test -s /var/cache/argus/policies.spl'",
    notify => Exec['update_pdp_rules'],
    require => Service['argus-pap']
  }

  #this does not even complain if pap is dead :'(
  exec {'update_pdp_rules':
    command => '/usr/sbin/pdpctl reloadPolicy',
    refreshonly => true,
    require => Service['argus-pdp']
  }

  File['/var/cache/argus'] -> File['/var/cache/argus/policies.spl'] -> Exec['delete_argus_policies'] -> Exec['update_argus_policies']

}
