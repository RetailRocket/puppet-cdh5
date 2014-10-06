# == Class cdh5::pig
#
# Installs and configures Apache Pig.
#
class cdh5::pig {
    package { 'pig':
        ensure => 'installed',
    }

    file { '/etc/pig/conf/pig.properties':
        content => template('cdh5/pig/pig.properties.erb'),
        require => Package['pig'],
    }
}
