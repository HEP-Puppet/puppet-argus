class argus::nfs(
  $mountpoint,
  $nfsmountoptions,
  $nfspath,
){

  package{['nfs-utils']:
    ensure => present,
  }

  #make sure the rpcbind and nfslock services are started prior to mounting the NFS share!
  #NB: this is for SLC6, on SLC5 we would need portmap instead of rpcbind. See cvmfs for an example.
  service { ['rpcbind','nfslock']:
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

  #Use autofs so that the NFS share is correctly mounted on startup and argus directly uses it
  #We use a direct mount declared in a mapfile auto.gridmapdir
  autofs::mount { '/-':
      map     => 'file:/etc/auto.gridmapdir',
    }

  #the automount maps are not managed by the autofs module (only master map and included master maps are)
  file { '/etc/auto.gridmapdir':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "${mountpoint} ${nfsmountoptions} ${nfspath}",
  }

  #Of course, make sure this is set up before argus is up and running.
  #auto.gridmapdir being a direct maps, any change should notify the autofs service.
  Class['argus::servicecert'] -> Package['nfs-utils'] -> Service['rpcbind','nfslock'] -> File['/etc/grid-security/gridmapdir','/etc/auto.gridmapdir'] -> Service['autofs'] -> Service['argus-pap','argus-pepd','argus-pdp']

}
