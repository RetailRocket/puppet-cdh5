# == Class cdh5::oozie::database::postgresql
# Configures and sets up a postgresql database for Oozie.
#
# Note that this class does not support running
# the Oozie database on a different host than where your
# oozie server will run.  Permissions will only be granted
# for localhost postgresql users, so oozie server must run on this node.
#
# Also, root must be able to run /usr/bin/postgresql with no password and have permissions
# to create databases and users and grant permissions.
#
# You probably shouldn't be including this class directly.  Instead, include
# cdh5::oozie::server with database => 'postgresql'.
#
# See: http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH4/4.2.1/CDH4-Installation-Guide/cdh4ig_topic_17_6.html
#
class cdh5::oozie::database::postgresql {
    
    if (!defined(Package['libpgjava'])) {
        package { 'libpgjava':
            ensure => 'installed',
        }
    }
    # symlink the postgresql.jar into /var/lib/hive/lib
    file { '/usr/lib/oozie/lib/postgresql.jar':
        ensure  => 'link',
        target  => '/usr/share/java/postgresql.jar',
        require => [ Package['libpgjava'], Package['oozie'] ]
    }

    $db_name = $cdh5::oozie::server::jdbc_database
    $db_user = $cdh5::oozie::server::jdbc_username
    $db_pass = $cdh5::oozie::server::jdbc_password
    
    postgresql::server::db { $db_name:
        user     => $db_user,
        password => postgresql_password($db_user, $db_pass),
        before   => Exec['oozie_postgresql_create_schema'],
    }

    # run ooziedb.sh to create the oozie database schema
    exec { 'oozie_postgresql_create_schema':
        command => '/usr/lib/oozie/bin/ooziedb.sh create -run',
        user    => $db_user,
        require => File['/usr/lib/oozie/lib/postgresql.jar'],
        unless  => "/usr/bin/psql -c '\dt' -d ${db_user} | grep -q oozie_sys",
    }
}
