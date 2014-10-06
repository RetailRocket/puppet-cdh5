# == Class cdh5::oozie
# Installs the oozie-client package
# And sets OOZIE_URL in /etc/profile.d/oozie.sh.
#
class cdh5::oozie(
    $oozie_host = 'h14.int.retailrocket.ru'
)
{
    # oozie server url
    $url = "http://$oozie_host:11000/oozie"

    package { 'oozie-client':
        ensure => 'installed',
    }

    # create a file in /etc/profile.d to export OOZIE_URL.
    file { '/etc/profile.d/oozie.sh':
        content => "# NOTE:  This file is managed by Puppet.

export OOZIE_URL='${url}'
",
        mode    => '0444',
    }
}
