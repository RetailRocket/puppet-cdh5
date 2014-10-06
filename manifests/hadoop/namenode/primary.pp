# == Class cdh5::hadoop::namenode::primary
# Hadoop Primary NameNode.
#
# This class is applied by cdh5::hadoop::master even
# if we aren't using HA Standby Namenodes.  The primary NameNode will be inferred
# as the first entry $cdh5::hadoop::namenode_hosts variable.  If we are using
# HA, then the primary NameNode will be transitioned to active as once NameNode
# has been formatted, before common HDFS directories are created.
#
class cdh5::hadoop::namenode::primary inherits cdh5::hadoop::namenode {
    # Go ahead and transision this primary namenode to active if we are using HA.
    #if ($::cdh5::hadoop::ha_enabled) {
    if ($ha_enabled) {
        $primary_namenode_id = $::cdh5::hadoop::primary_namenode_id

        exec { 'haaadmin-transitionToActive':
            # $namenode_id is set in parent cdh5::hadoop::namenode class.
            command     => "/usr/bin/hdfs haadmin -transitionToActive ${primary_namenode_id}",
            unless      => "/usr/bin/hdfs haadmin -getServiceState    ${primary_namenode_id} | /bin/grep -q active",
            user        => 'hdfs',
            # Only run this command if the namenode was just formatted
            # and after the namenode has started up.
            refreshonly => true,
            subscribe   => Exec['hadoop-namenode-format'],
            require     => Service['hadoop-hdfs-namenode'],
        }
        # Make sure NameNode is running and active
        # before we try to create common HDFS directories.
        cdh5::Hadoop::Directory {
            require => Exec['haaadmin-transitionToActive'],
        }
    }
    else {
        # Make sure NameNode is running
        # before we try to create common HDFS directories.
        Cdh5::Hadoop::Directory {
            require =>  Service['hadoop-hdfs-namenode'],
        }
    }

    # Create common HDFS directories.

    # sudo -u hdfs hadoop fs -mkdir /tmp
    # sudo -u hdfs hadoop fs -chmod 1777 /tmp
    cdh5::hadoop::directory { '/tmp':
        owner   => 'hdfs',
        group   => 'hdfs',
        mode    => '1777',
    }

    # sudo -u hdfs hadoop fs -mkdir /user
    # sudo -u hdfs hadoop fs -chmod 0775 /user
    # sudo -u hdfs hadoop fs -chown hdfs:hadoop /user
    cdh5::hadoop::directory { '/user':
        owner   => 'hdfs',
        group   => 'hadoop',
        mode    => '0775',
    }

    # sudo -u hdfs hadoop fs -mkdir /user/hdfs
    cdh5::hadoop::directory { '/user/hdfs':
        owner   => 'hdfs',
        group   => 'hdfs',
        mode    => '0755',
        require => Cdh5::Hadoop::Directory['/user'],
    }

    # sudo -u hdfs hadoop fs -mkdir /var
    cdh5::hadoop::directory { '/var':
        owner   => 'hdfs',
        group   => 'hdfs',
        mode    => '0755',
    }

    # sudo -u hdfs hadoop fs -mkdir /var/lib
    cdh5::hadoop::directory { '/var/lib':
        owner   => 'hdfs',
        group   => 'hdfs',
        mode    => '0755',
        require => Cdh5::Hadoop::Directory['/var'],
    }

    # sudo -u hdfs hadoop fs -mkdir /var/log
    cdh5::hadoop::directory { '/var/log':
        owner   => 'hdfs',
        group   => 'hdfs',
        mode    => '0755',
        require => Cdh5::Hadoop::Directory['/var'],
    }
}
