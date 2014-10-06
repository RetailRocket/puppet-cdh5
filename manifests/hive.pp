# == Class cdh5::hive
#
# Installs Hive packages (needed for Hive Client).
# Use this in conjunction with cdh5::hive::master to install and set up a
# Hive Server and Hive Metastore.
#
# == Parameters
# $metastore_host                - fqdn of the metastore host
# $zookeeper_hosts               - Array of zookeeper hostname/IP(:port)s.
#                                  Default: undef (zookeeper lock management
#                                  will not be used).
#
# $jdbc_database                 - Metastore JDBC database name.
#                                  Default: 'hive_metastore'
# $jdbc_username                 - Metastore JDBC username.  Default: hive
# $jdbc_password                 - Metastore JDBC password.  Default: hive
# $jdbc_host                     - Metastore JDBC hostname.  Default: localhost
# $jdbc_port                     - Metastore JDBC port.      Default: 3306
# $jdbc_driver                   - Metastore JDBC driver class name.
#                                  Default: org.apache.derby.jdbc.EmbeddedDriver
# $jdbc_protocol                 - Metastore JDBC protocol.  Default: mysql
#
# $exec_parallel_thread_number   - Number of jobs at most can be executed in parallel.
#                                  Set this to 0 to disable parallel execution.
# $optimize_skewjoin             - Enable or disable skew join optimization.
#                                  Default: false
# $skewjoin_key                  - Number of rows where skew join is used.
#                                - Default: 10000
# $skewjoin_mapjoin_map_tasks    - Number of map tasks used in the follow up
#                                  map join jobfor a skew join.   Default: 10000.
# $skewjoin_mapjoin_min_split    - Skew join minimum split size.  Default: 33554432
#
# $stats_enabled                 - Enable or disable temp Hive stats.  Default: false
# $stats_dbclass                 - The default database class that stores
#                                  temporary hive statistics.  Default: jdbc:derby
# $stats_jdbcdriver              - JDBC driver for the database that stores
#                                  temporary hive statistics.
#                                  Default: org.apache.derby.jdbc.EmbeddedDriver
# $stats_dbconnectionstring      - Connection string for the database that stores
#                                  temporary hive statistics.
#                                  Default: jdbc:derby:;databaseName=TempStatsStore;create=true
#
class cdh5::hive(
    $metastore_host              = $cdh5::hive::defaults::$metastore_host,
    $metastore_client_socket_timeout = $cdh5::hive::defaults::metastore_client_socket_timeout,
    $zookeeper_hosts             = $cdh5::hive::defaults::zookeeper_hosts,

    $jdbc_database               = $cdh5::hive::defaults::jdbc_database,
    $jdbc_username               = $cdh5::hive::defaults::jdbc_username,
    $jdbc_password               = $cdh5::hive::defaults::jdbc_password,
    $jdbc_host                   = $cdh5::hive::defaults::jdbc_host,
    $jdbc_port                   = $cdh5::hive::defaults::jdbc_port,
    $jdbc_driver                 = $cdh5::hive::defaults::jdbc_driver,
    $jdbc_protocol               = $cdh5::hive::defaults::jdbc_protocol,

    $exec_parallel_thread_number = $cdh5::hive::defaults::exec_parallel_thread_number,
    $optimize_skewjoin           = $cdh5::hive::defaults::optimize_skewjoin,
    $skewjoin_key                = $cdh5::hive::defaults::skewjoin_key,
    $skewjoin_mapjoin_map_tasks  = $cdh5::hive::defaults::skewjoin_mapjoin_map_tasks,

    $stats_enabled               = $cdh5::hive::defaults::stats_enabled,
    $stats_dbclass               = $cdh5::hive::defaults::stats_dbclass,
    $stats_jdbcdriver            = $cdh5::hive::defaults::stats_jdbcdriver,
    $stats_dbconnectionstring    = $cdh5::hive::defaults::stats_dbconnectionstring,

    $hive_heap_size_mb           = '4096',
    $hive_site_template          = $cdh5::hive::defaults::hive_site_template,
    $hive_exec_log4j_template    = $cdh5::hive::defaults::hive_exec_log4j_template
) inherits cdh5::hive::defaults
{
    package { 'hive':
        ensure => 'installed',
    }

    # Make sure hive-site.xml is not world readable on the
    # metastore host.  On the metastore host, hive-site.xml
    # will contain database connection credentials.
    $hive_site_mode = $metastore_host ? {
        $::fqdn => '0444',
        default => '0644',
    }
    file { '/etc/hive/conf/hive-site.xml':
        content => template($hive_site_template),
        mode    => $hive_site_mode,
        owner   => 'hive',
        group   => 'hive',
        require => Package['hive'],
    }
    file { "/etc/hive/conf/hive-env.sh":
        content => template("cdh5/hive/hive-env.sh.erb"),
        owner   => root,
        require => Package["hive"];
    }
    file { '/etc/hive/conf/hive-exec-log4j.properties':
        content => template($hive_exec_log4j_template),
    }
}
