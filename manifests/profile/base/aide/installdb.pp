# Initialises new database and copies it to the correct naming convention
class tripleo::profile::base::aide::installdb (
  $step = hiera('step'),
  ) {

    exec { 'aide init':
      command     => "/usr/sbin/aide --init --config /etc/aide.conf'",
      user        => 'root',
      refreshonly => true,
      subscribe   => Concat['aide.conf']
    }

    exec { 'install aide db':
      command     => "/bin/cp -f /var/lib/aide/aide.db.new /var/lib/aide/aide.db",
      user        => 'root',
      refreshonly => true,
      subscribe   => Exec['aide init']
    }

    file { '/var/lib/aide/aide.db':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0600',
      seluser => 'unconfined_u',
      require => Exec['install aide db']
    }

    file { '/var/lib/aide/aide.db.new.gz':
      owner   => root,
      group   => root,
      mode    => '0600',
      seluser => 'unconfined_u',
      require => Exec['aide init']
    }
}
