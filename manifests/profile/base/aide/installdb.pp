# Initialises new database and copies it to the correct naming convention
class tripleo::profile::base::aide::aide::installdb ( inherits aide {
  exec { 'aide init':
    command     => "${::aide::params::aide_path} --init --config ${::aide::conf_path}",
    user        => 'root',
    refreshonly => true,
    subscribe   => Concat['aide.conf']
  }

  exec { 'install aide db':
    command     => "/bin/cp -f ${::aide::db_temp_path} ${::aide::db_path}",
    user        => 'root',
    refreshonly => true,
    subscribe   => Exec['aide init']
  }

  file { $::aide::db_path:
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
