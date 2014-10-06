# == Class cdh5::mahout
#
# Installs and configures Apache Pig.
#
class cdh5::mahout {
    package { 'mahout':
        ensure => 'installed',
    }

    file { '/etc/mahout/conf/mahout.properties':
        content => template('cdh4/mahout/mahout.properties.erb'),
        require => Package['mahout'],
    }
}
