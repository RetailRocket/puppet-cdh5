# == Class hive::defaults
# Default Hive configs
#
class cdh5::hive::defaults {
    $metastore_host              = undef
    $zookeeper_hosts             = undef

    $metastore_client_socket_timeout = 300 # sec

    $jdbc_driver                 = 'org.postgresql.Driver'
    $jdbc_protocol               = 'postgresql'
    $jdbc_database               = 'metastore'
    $jdbc_host                   = 'localhost'
    $jdbc_port                   = 5432
    $jdbc_username               = 'hive'
    $jdbc_password               = 'hive'

    $exec_parallel_thread_number = 0  # set this to 0 to disable hive.exec.parallel
    $optimize_skewjoin           = false
    $skewjoin_key                = 10000
    $skewjoin_mapjoin_map_tasks  = 10000
    $skewjoin_mapjoin_min_split  = 33554432

    $stats_enabled               = false
    $stats_dbclass               = 'jdbc:derby'
    $stats_jdbcdriver            = 'org.apache.derby.jdbc.EmbeddedDriver'
    $stats_dbconnectionstring    = 'jdbc:derby:;databaseName=TempStatsStore;create=true'

    # Default puppet paths to template config files.
    # This allows us to use custom template config files
    # if we want to override more settings than this
    # module yet supports.
    $hive_site_template          = 'cdh5/hive/hive-site.xml.erb'
    $hive_exec_log4j_template    = 'cdh5/hive/hive-exec-log4j.properties.erb'
}
