#
# == Class cdh5::hadoop
#
# Installs the main Hadoop/HDFS packages and config files.  This
# By default this will set Hadoop config files to run YARN (MapReduce 2).
#
# This assumes that your JBOD mount points are already
# formatted and mounted at the locations listed in $datanode_mounts.
#
# dfs.datanode.data.dir will be set to each of ${dfs_data_dir_mounts}/$data_path
# yarn.nodemanager.local-dirs will be set to each of ${dfs_data_dir_mounts}/$yarn_local_path
# yarn.nodemanager.log-dirs will be set to each of ${dfs_data_dir_mounts}/$yarn_logs_path
#
# == Parameters
#   $namenode_hosts             - Array of NameNode host(s).  The first entry in this
#                                 array will be the primary NameNode.  The primary NameNode
#                                 will also be used as the host for the historyserver, proxyserver,
#                                 and resourcemanager.   Use multiple hosts hosts if you
#                                 configuring Hadoop with HA NameNodes.
#   $dfs_name_dir               - Path to hadoop NameNode name directory.  This
#                                 can be an array of paths or a single string path.
#   $nameservice_id             - Arbitrary logical HDFS cluster name.  Only set this
#                                 if you want to use HA NameNode.
#   $journalnode_hosts          - Array of JournalNode hosts.  This will be ignored
#                                 if $nameservice_id is not set.
#   $dfs_journalnode_edits_dir  - Path to JournalNode edits dir.  This will be
#                                 ignored if $nameservice_id is not set.
#   $config_directory           - Path of the hadoop config directory.
#   $datanode_mounts            - Array of JBOD mount points.  Hadoop datanode and
#                                 mapreduce/yarn directories will be here.
#   $dfs_data_path              - Path relative to JBOD mount point for HDFS data directories.
#   $enable_jmxremote           - enables remote JMX connections for all Hadoop services.
#                                 Ports are not currently configurable.  Default: true.
#   $yarn_local_path            - Path relative to JBOD mount point for yarn local directories.
#   $yarn_logs_path             - Path relative to JBOD mount point for yarn log directories.
#   $dfs_block_size             - HDFS block size in bytes.  Default 64MB.
#   $io_file_buffer_size
#   $map_tasks_maximum
#   $reduce_tasks_maximum
#   $mapreduce_job_reuse_jvm_num_tasks
#   $reduce_parallel_copies
#   $map_memory_mb
#   $reduce_memory_mb
#   $mapreduce_system_dir
#   $mapreduce_task_io_sort_mb
#   $mapreduce_task_io_sort_factor
#   $mapreduce_map_java_opts
#   $mapreduce_child_java_opts
#   $mapreduce_intermediate_compression   - If true, intermediate MapReduce data
#                                           will be compressed with Snappy.  Default: true.
#   $mapreduce_final_compession           - If true, Final output of MapReduce
#                                           jobs will be compressed with Snappy. Default: false.
#   $yarn_nodemanager_resource_memory_mb
#   $yarn_resourcemanager_scheduler_class - If you change this (e.g. to
#                                           FairScheduler), you should also provide
#                                           your own scheduler config .xml files
#                                           outside of the cdh4 module.
#   $use_yarn
#   $ganglia_hosts                        - Set this to an array of ganglia host:ports
#                                           if you want to enable ganglia sinks in hadoop-metrics2.properites
#   $net_topology_script_template         - Puppet ERb template path  to script that will be
#                                           invoked to resolve node names to row or rack assignments.
#                                           Default: undef
#
class cdh5::hadoop(
    $namenode_hosts                          = undef,
    $dfs_name_dir                            = '/mnt/hdfs',
    
    $namenode_jmxremote_port                 = undef, # 9980
    $datanode_jmxremote_port                 = undef, # 9981
    $secondary_namenode_jmxremote_port       = undef, # 9982
    $resourcemanager_jmxremote_port          = undef, # 9983
    $nodemanager_jmxremote_port              = undef, # 9984
    $proxyserver_jmxremote_port              = undef, # 9985
    $jobtracker_jmxremote_port               = undef, # 9986

    $namenode_heap_size                      = $::cdh5::hadoop::defaults::namenode_heap_size,
    $jobtracker_heap_size                    = $::cdh5::hadoop::defaults::jobtracker_heap_size,

    $config_directory                        = $::cdh5::hadoop::defaults::config_directory,

    $nameservice_id                          = $::cdh5::hadoop::defaults::nameservice_id,
    $journalnode_hosts                       = $::cdh5::hadoop::defaults::journalnode_hosts,
    $dfs_journalnode_edits_dir               = $::cdh5::hadoop::defaults::dfs_journalnode_edits_dir,

    $datanode_mounts                         = $::cdh5::hadoop::defaults::datanode_mounts,
    $dfs_data_path                           = $::cdh5::hadoop::defaults::dfs_data_path,

    $yarn_local_path                         = $::cdh5::hadoop::defaults::yarn_local_path,
    $yarn_logs_path                          = $::cdh5::hadoop::defaults::yarn_logs_path,
    $dfs_block_size                          = $::cdh5::hadoop::defaults::dfs_block_size,
    $dfs_namenode_fs_limits_min_block_size   = $::cdh5::hadoop::defaults::dfs_namenode_fs_limits_min_block_size,
    $enable_jmxremote                        = $::cdh5::hadoop::defaults::enable_jmxremote,
    $enable_webhdfs                          = $::cdh5::hadoop::defaults::enable_webhdfs,
    $io_file_buffer_size                     = $::cdh5::hadoop::defaults::io_file_buffer_size,
    $mapreduce_system_dir                    = $::cdh5::hadoop::defaults::mapreduce_system_dir,
    $mapreduce_map_tasks_maximum             = $::cdh5::hadoop::defaults::mapreduce_map_tasks_maximum,
    $mapreduce_reduce_tasks_maximum          = $::cdh5::hadoop::defaults::mapreduce_reduce_tasks_maximum,
    $mapreduce_job_reuse_jvm_num_tasks       = $::cdh5::hadoop::defaults::mapreduce_job_reuse_jvm_num_tasks,
    $mapreduce_reduce_shuffle_parallelcopies = $::cdh5::hadoop::defaults::mapreduce_reduce_shuffle_parallelcopies,
    $mapreduce_map_memory_mb                 = $::cdh5::hadoop::defaults::mapreduce_map_memory_mb,
    $mapreduce_reduce_memory_mb              = $::cdh5::hadoop::defaults::mapreduce_reduce_memory_mb,
    $mapreduce_task_io_sort_mb               = $::cdh5::hadoop::defaults::mapreduce_task_io_sort_mb,
    $mapreduce_task_io_sort_factor           = $::cdh5::hadoop::defaults::mapreduce_task_io_sort_factor,
    $mapreduce_map_java_opts                 = $::cdh5::hadoop::defaults::mapreduce_map_java_opts,
    $mapreduce_reduce_java_opts              = $::cdh5::hadoop::defaults::mapreduce_reduce_java_opts,
    $mapreduce_intermediate_compression      = $::cdh5::hadoop::defaults::mapreduce_intermediate_compression,
    $mapreduce_final_compession              = $::cdh5::hadoop::defaults::mapreduce_final_compession,
    $yarn_nodemanager_resource_memory_mb     = $::cdh5::hadoop::defaults::yarn_nodemanager_resource_memory_mb,
    $yarn_resourcemanager_scheduler_class    = $::cdh5::hadoop::defaults::yarn_resourcemanager_scheduler_class,
    $use_yarn                                = $::cdh5::hadoop::defaults::use_yarn,
    $ganglia_hosts                           = $::cdh5::hadoop::defaults::ganglia_hosts,
    $net_topology_script_template            = $::cdh5::hadoop::defaults::net_topology_script_template,
    ###RR
    $fs_trash_interval                       = $::cdh5::hadoop::defaults::fs_trash_interval,
    $io_compression_codecs                   = $::cdh5::hadoop::defaults::io_compression_codecs,
    $hadoop_security_authentication          = $::cdh5::hadoop::defaults::hadoop_security_authentication,
    $hadoop_rpc_protection                   = $::cdh5::hadoop::defaults::hadoop_rpc_protection,
    $hadoop_security_auth_to_local           = $::cdh5::hadoop::defaults::hadoop_security_auth_to_local,
    $hadoop_proxyuser_hue_hosts              = $::cdh5::hadoop::defaults::hadoop_proxyuser_hue_hosts,
    $hadoop_proxyuser_hue_groups             = $::cdh5::hadoop::defaults::hadoop_proxyuser_hue_groups,
    $hadoop_proxyuser_oozie_hosts            = $::cdh5::hadoop::defaults::hadoop_proxyuser_oozie_hosts,
    $hadoop_proxyuser_oozie_groups           = $::cdh5::hadoop::defaults::hadoop_proxyuser_oozie_groups,
    $hadoop_tmp_dir			     = $::cdh5::hadoop::defaults::hadoop_tmp_dir,

    ##hdfs-site.xml
    $dfs_client_use_datanode_hostname        = $::cdh5::hadoop::defaults::dfs_client_use_datanode_hostname,
    $fs_permissions_umask_mode               = $::cdh5::hadoop::defaults::fs_permissions_umask_mode,
    $dfs_client_read_shortcircuit            = $::cdh5::hadoop::defaults::dfs_client_read_shortcircuit,
    $dfs_domain_socket_path                  = $::cdh5::hadoop::defaults::dfs_domain_socket_path,
    $dfs_client_read_shortcircuit_skip_checksum = $::cdh5::hadoop::defaults::dfs_client_read_shortcircuit_skip_checksum,
    $dfs_client_domain_socket_data_traffic   = $::cdh5::hadoop::defaults::dfs_client_domain_socket_data_traffic,
    $dfs_datanode_hdfs_blocks_metadata_enabled = $::cdh5::hadoop::defaults::dfs_datanode_hdfs_blocks_metadata_enabled,
    $dfs_replication			     = $::cdh5::hadoop::defaults::dfs_replication,
    $dfs_datanode_balance_bandwidthPerSec    = $::cdh5::hadoop::defaults::dfs_datanode_balance_bandwidthPerSec,
    $dfs_datanode_max_xcievers               = $::cdh5::hadoop::defaults::dfs_datanode_max_xcievers,

    ##mapred-site.xml
    $mapred_job_tracker_http_address         = $::cdh5::hadoop::defaults::mapred_job_tracker_http_address,
    $mapreduce_job_counters_max              = $::cdh5::hadoop::defaults::mapreduce_job_counters_max,
    $mapred_output_compress                  = $::cdh5::hadoop::defaults::mapred_output_compress,
    $mapred_output_compression_type          = $::cdh5::hadoop::defaults::mapred_output_compression_type,
    $mapred_output_compression_codec         = $::cdh5::hadoop::defaults::mapred_output_compression_codec,
    $mapred_map_output_compression_codec     = $::cdh5::hadoop::defaults::mapred_map_output_compression_codec,
    $mapred_compress_map_output              = $::cdh5::hadoop::defaults::mapred_compress_map_output,
    $zlib_compress_level                     = $::cdh5::hadoop::defaults::zlib_compress_level,
    $io_sort_factor                          = $::cdh5::hadoop::defaults::io_sort_factor,
    $io_sort_record_percent                  = $::cdh5::hadoop::defaults::io_sort_record_percent,
    $io_sort_spill_percent                   = $::cdh5::hadoop::defaults::io_sort_spill_percent,
    $mapred_reduce_parallel_copies           = $::cdh5::hadoop::defaults::mapred_reduce_parallel_copies,
    $mapred_submit_replication               = $::cdh5::hadoop::defaults::mapred_submit_replication,
    $mapred_reduce_tasks                     = $::cdh5::hadoop::defaults::mapred_reduce_tasks,
    $mapred_userlog_retain_hours             = $::cdh5::hadoop::defaults::mapred_userlog_retain_hours,
    $io_sort_mb                              = $::cdh5::hadoop::defaults::io_sort_mb,
    $mapred_child_java_opts                  = $::cdh5::hadoop::defaults::mapred_child_java_opts,
    $mapred_job_reuse_jvm_num_tasks          = $::cdh5::hadoop::defaults::mapred_job_reuse_jvm_num_tasks,
    $mapred_map_tasks_speculative_execution  = $::cdh5::hadoop::defaults::mapred_map_tasks_speculative_execution,
    $mapred_tasktracker_map_tasks_maximum    = $::cdh5::hadoop::defaults::mapred_tasktracker_map_tasks_maximum,
    $mapred_tasktracker_reduce_tasks_maximum = $::cdh5::hadoop::defaults::mapred_tasktracker_reduce_tasks_maximum,
    $ha_jobtracker			     = $::cdh5::hadoop::defaults::ha_jobtracker,
    

) inherits cdh5::hadoop::defaults
{

    # If $dfs_name_dir is a list, this will be the
    # first entry in the list.  Else just $dfs_name_dir.
    # This used in a couple of execs throughout this module.
    $dfs_name_dir_main = inline_template('<%= (dfs_name_dir.class == Array) ? dfs_name_dir[0] : dfs_name_dir %>')

    # Set a boolean for use in logic elsewhere to
    # determine if HA NameNode will be used.
    $ha_enabled = $nameservice_id ? {
        undef   => false,
        default => true,
    }

    # Parameter Validation:
    if ($ha_enabled and !$journalnode_hosts) {
        fail('Must provide multiple $journalnode_hosts when using HA and setting $nameservice_id.')
    }


    # Assume the primary namenode is the first entry in $namenode_hosts,
    # Set a variable here for reference in other classes.
    $primary_namenode_host = $namenode_hosts[0]
    # This is the primary NameNode ID used to identify
    # a NameNode when running HDFS with a logical nameservice_id.
    # We can't use '.' characters because NameNode IDs
    # will be used in the names of some Java properties,
    # which are '.' delimited.
    $primary_namenode_id   = inline_template('<%= @primary_namenode_host.tr(\'.\', \'-\') %>')
	
    if $operatingsystem == "Ubuntu"{
      apt::source { 'cloudera':
              location    => 'http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/',
              release     => 'precise-cdh4',
              repos       => 'contrib',
              key_source => 'http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/archive.key',
              key         => "327574EE02A818DD",
              include_src => false,
      }
    } else {
      apt::source { 'cloudera':
              location    => 'http://archive.cloudera.com/cdh5/debian/wheezy/amd64/cdh',
              release     => 'wheezy-cdh5',
              repos       => 'contrib',
              key_source => 'http://archive.cloudera.com/cdh5/debian/wheezy/amd64/cdh/archive.key',
              key         => "327574EE02A818DD",
              include_src => false,
      }
    }
    
    package { 'hadoop-client':
        ensure => 'installed',
        require => Apt::Source['cloudera'],
    }

    if $operatingsystem == "Ubuntu"{
       apt::source { 'cloudera-impala':
              location   => 'http://archive.cloudera.com/gplextras/ubuntu/precise/amd64/gplextras',
              release    => 'precise-gplextras4.2.0',
              repos      => 'contrib',
              key_source => 'http://archive.cloudera.com/gplextras/ubuntu/precise/amd64/gplextras/archive.key',
              include_src => false,
       }
    } else {
      apt::source { 'cloudera-impala':
              location => 'http://archive.cloudera.com/gplextras5/debian/wheezy/amd64/gplextras',
              release => 'wheezy-gplextras5',
              repos => 'contrib',
              key_source => 'http://archive.cloudera.com/gplextras5/debian/wheezy/amd64/gplextras/archive.key',
              include_src => false,
      }
      apt::source { 'cloudera-lzo-cdh4':
              location => 'http://archive-primary.cloudera.com/gplextras/debian/squeeze/amd64/gplextras/',
              release => 'squeeze-gplextras4 ',
              repos => 'contrib',
              key_source => 'http://archive-primary.cloudera.com/gplextras/debian/squeeze/amd64/gplextras/archive.key',
              include_src => false,
      }
    }

    package { ['hadoop-lzo-cdh4', 'impala-lzo', 'liblzo2-2', 'liblzo2-dev' ]:
        ensure => installed,
        require => Apt::Source['cloudera-impala'],
    }


    # All config files require hadoop-client package.
    #File {
    #    require => Package['hadoop-client']
    #}

    # ensure for yarn specific config files.
    $yarn_ensure = $use_yarn ? {
        false   => 'absent',
        default => 'present',
    }

    # Render net-topology.sh from $net_topology_script_template
    # if it was given.
    $net_topology_script_ensure = $net_topology_script_template ? {
        undef   => 'absent',
        default => 'present',
    }
    $net_topology_script_path = "${config_directory}/net-topology.sh"
    file { $net_topology_script_path:
        ensure  => $net_topology_script_ensure,
        mode    => '0755',
        require => Package['hadoop-client'],
    }
    # Conditionally overriding content attribute since
    # $net_topology_script_template is default undef.
    if ($net_topology_script_ensure == 'present') {
        File[$net_topology_script_path] {
            content => template($net_topology_script_template),
            require => Package['hadoop-client'],
        }
    }


    file { "${config_directory}/log4j.properties":
        content => template('cdh5/hadoop/log4j.properties.erb'),
        require => Package['hadoop-client'],
    }

    file { "${config_directory}/core-site.xml":
        content => template('cdh5/hadoop/core-site.xml.erb'),
        require => Package['hadoop-client'],
    }

    file { "$config_directory/hdfs-site.xml":
        content => template('cdh5/hadoop/hdfs-site.xml.erb'),
        require => Package['hadoop-client'],
    }

    file {"$config_directory/httpfs-site.xml":
        content => template('cdh5/hadoop/httpfs-site.xml.erb'),
        require => Package['hadoop-client'],
    }

    file { "${config_directory}/hadoop-env.sh":
        content => template('cdh5/hadoop/hadoop-env.sh.erb'),
        require => Package['hadoop-client'],
    }

    file { "${config_directory}/mapred-site.xml":
        content => template('cdh5/hadoop/mapred-site.xml.erb'),
	require => Package['hadoop-client'],
        /*require => [ Package['hadoop-client'], Class['cdh5::hadoop::tasktracker'] ],
        notify  => Service['hadoop-0.20-mapreduce-tasktracker']*/
    }

    file { "${config_directory}/yarn-site.xml":
        ensure  => $yarn_ensure,
        content => template('cdh5/hadoop/yarn-site.xml.erb'),
        require => Package['hadoop-client'],
    }

    file { "${config_directory}/yarn-env.sh":
        ensure  => $yarn_ensure,
        content => template('cdh5/hadoop/yarn-env.sh.erb'),
        require => Package['hadoop-client'],
    }

    # Render hadoop-metrics2.properties
    # if we have Ganglia Hosts to send metrics to.
    $hadoop_metrics2_ensure = $ganglia_hosts ? {
        undef   => 'absent',
        default => 'present',
    }
    file { "${config_directory}/hadoop-metrics2.properties":
        ensure  => $hadoop_metrics2_ensure,
        content => template('cdh5/hadoop/hadoop-metrics2.properties.erb'),
        require => Package['hadoop-client'],
    }


    # If the current node is meant to be JournalNode,
    # include the journalnode class.  JournalNodes can
    # be started at any time.
    if ($journalnode_hosts and (
            ($::fqdn           and $::fqdn           in $journalnode_hosts) or
            ($::ipaddress      and $::ipaddress      in $journalnode_hosts) or
            ($::ipaddress_eth1 and $::ipaddress_eth1 in $journalnode_hosts)))
    {
            include cdh5::hadoop::journalnode
    }

    file { "/etc/hosts": 
            ensure          => present,
            content => template("cdh5/system/hosts.erb"),
    }

    file_line { "change_pam.d" :
            path => "/etc/pam.d/common-session",
            line => "session required        pam_limits.so",
    }


    /*
    limits::conf { 
        "all": domain => "*", type => "-", item => "nofile", value => "10000"
    }
    */

    ##HDFS & MAPRED LIMITS REWRITE
    file { "/etc/security/limits.d/hdfs.conf" :
            ensure => present,
            content => template("cdh5/system/hdfs_limits.erb"),
    }

    file { "/etc/security/limits.d/mapred.conf" : 
            ensure => present,
            content => template("cdh5/system/mapred_limits.erb"),
    }

    file { "/etc/security/limits.d/mapreduce.conf" :
            ensure => present,
            content => template("cdh5/system/mapreduce_limits.erb"),
    }
}
