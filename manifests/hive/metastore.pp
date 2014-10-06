# == Class cdh5::hive::metastore
#
class cdh5::hive::metastore
{
    Class['cdh5::hive'] -> Class['cdh5::hive::metastore']

    package { 'hive-metastore':
        ensure => 'installed',
    }

    service { 'hive-metastore':
        ensure     => 'running',
        require    => Package['hive-metastore'],
        hasrestart => true,
        hasstatus  => true,
    }
}
