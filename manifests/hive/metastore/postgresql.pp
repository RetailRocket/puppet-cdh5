# == Class cdh5::hive::metastore::postgresql
# Configures and sets up a postgresql metastore for Hive.
#
# Note that this class does not support running
# the Metastore database on a different host than where your
# hive-metastore service will run.  Permissions will only be granted
# for localhost postgresql users, so hive-metastore must run on this node.
#
# Also, root must be able to run /usr/bin/postgresql with no password and have permissions
# to create databases and users and grant permissions.
#
# See: http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH4/latest/CDH4-Installation-Guide/cdh4ig_hive_metastore_configure.html
#
# == Parameters
# $schema_version - When installing the metastore database, this version of
#                   the schema will be created.  This must match an .sql file
#                   schema version found in /usr/lib/hive/scripts/metastore/upgrade/postgres.
#                   Default: 0.10.0
#
class cdh5::hive::metastore::postgresql($schema_version = '0.12.0') {
    Class['cdh5::hive'] -> Class['cdh5::hive::metastore::postgresql']

    if (!defined(Package['libpgjava'])) {
        package { 'libpgjava':
            ensure => 'installed',
        }
    }
    # symlink the postgresql.jar into /var/lib/hive/lib
    file { '/usr/lib/hive/lib/postgresql.jar':
        ensure  => 'link',
        target  => '/usr/share/java/postgresql.jar',
        require => Package['libpgjava'],
    }

    $db_name = $cdh5::hive::jdbc_database
    $db_user = $cdh5::hive::jdbc_username
    $db_pass = $cdh5::hive::jdbc_password
	
    postgresql::server::db { $db_name:
        user     => $db_user,
        password => postgresql_password($db_user, $db_pass),
        before   => Exec['hive_postgresql_create_schema'],
    }

    # hive is going to need a metastore database.
    exec { 'hive_postgresql_create_schema':
        command => "/usr/bin/psql -d ${db_name} -f /usr/lib/hive/scripts/metastore/upgrade/postgres/hive-schema-${schema_version}.postgres.sql",
        user    => $db_user,
        unless  => "/usr/bin/psql -d ${db_name} -c '\dt' | grep -q ${db_user}",
    }
}
