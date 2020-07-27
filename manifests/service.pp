class argus::service {
  service{'argus-pap':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    tag        => 'argus',
  }

  -> service{'argus-pdp':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    tag        => 'argus',
  }

  -> service{'argus-pepd':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    tag        => 'argus',
  }
}
