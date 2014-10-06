# == Class cdh5::hadoop::defaults
# Default parameters for cdh5::hadoop configuration.
#
class cdh5::hadoop::defaults {
    $config_directory                        = '/etc/hadoop/conf'

    $nameservice_id                          = undef
    $journalnode_hosts                       = undef
    $dfs_journalnode_edits_dir               = undef

    $namenode_heap_size                      = '4G'
    $jobtracker_heap_size                    = '16G'

    $datanode_mounts                         = [ '/dfs/dn1','/dfs/dn2' ]
    $dfs_data_path                           = 'hdfs/dn'
    $mapred_data_path                        = 'mapred/local'
    $yarn_local_path                         = 'yarn/local'
    $yarn_logs_path                          = 'yarn/logs'
    $enable_jmxremote                        = true
    $enable_webhdfs                          = true
    $mapreduce_system_dir                    = undef
    $io_file_buffer_size                     = '65536'
    $mapreduce_map_tasks_maximum             = undef
    $mapreduce_reduce_tasks_maximum          = undef
    $mapreduce_job_reuse_jvm_num_tasks       = undef
    $mapreduce_reduce_shuffle_parallelcopies = undef
    $mapreduce_map_memory_mb                 = undef
    $mapreduce_reduce_memory_mb              = undef
    $mapreduce_task_io_sort_mb               = undef
    $mapreduce_task_io_sort_factor           = undef
    $mapreduce_map_java_opts                 = undef
    $mapreduce_reduce_java_opts              = undef
    $mapreduce_intermediate_compression      = true
    $mapreduce_final_compression             = false
    $yarn_nodemanager_resource_memory_mb     = undef
    $yarn_resourcemanager_scheduler_class    = undef
    $use_yarn                                = false
    $ganglia_hosts                           = undef
    $net_topology_script_template            = undef
    $ha_jobtracker			     = false

    ##RR
    
    ##core-site.xml
    $fs_trash_interval			     = 1
    $io_compression_codecs                   = [
                                                 'org.apache.hadoop.io.compress.DefaultCodec',
                                                 'org.apache.hadoop.io.compress.GzipCodec',
                                                 'org.apache.hadoop.io.compress.BZip2Codec',
                                                 'org.apache.hadoop.io.compress.DeflateCodec',
                                                 'org.apache.hadoop.io.compress.SnappyCodec',
                                                 'org.apache.hadoop.io.compress.Lz4Codec',
                                                 'com.hadoop.compression.lzo.LzoCodec',
                                                 'com.hadoop.compression.lzo.LzopCodec',
                                               ]
    $hadoop_security_authentication	     = 'simple'
    $hadoop_rpc_protection		     = 'authentication'
    $hadoop_security_auth_to_local           = 'DEFAULT'
    $hadoop_proxyuser_hue_hosts              = '*'
    $hadoop_proxyuser_hue_groups	     = '*'
    $hadoop_proxyuser_oozie_hosts	     = '*'
    $hadoop_proxyuser_oozie_groups	     = '*'
    $hadoop_tmp_dir			     = '/tmp/hadoop-${user.name}'

    ##hdfs-site.xml
    $fs_permissions_umask_mode	             = '022'
    $dfs_client_use_datanode_hostname         = 'false'    
    $dfs_block_size                          = '268435456' # 256MB
    #$dfs_block_size                          = '16384'
    $dfs_namenode_fs_limits_min_block_size   = undef
    $dfs_client_read_shortcircuit	     = 'false'   
    $dfs_domain_socket_path		     = '/var/run/hdfs-sockets/dn'
    $dfs_client_read_shortcircuit_skip_checksum = 'false'
    $dfs_client_domain_socket_data_traffic   = 'false'
    $dfs_datanode_hdfs_blocks_metadata_enabled = 'true'
    $dfs_replication			     = '3'
    $dfs_datanode_balance_bandwidthPerSec    = '52428800'
    $dfs_datanode_max_xcievers               = '128000'
  
    ##mapred-site.xml
    $mapred_job_tracker_http_address         = '0.0.0.0'
    $mapreduce_job_counters_max		     = 120
    $mapred_output_compress		     = 'false'
    $mapred_output_compression_type	     = 'BLOCK'
    $mapred_output_compression_codec	     = 'org.apache.hadoop.io.compress.Lz4Codec'
    $mapred_map_output_compression_codec     = 'org.apache.hadoop.io.compress.SnappyCodec'
    $mapred_compress_map_output		     = 'true'
    $zlib_compress_level    	             = 'DEFAULT_COMPRESSION'
    $io_sort_factor			     = '64'
    $io_sort_record_percent                  = '0.3'
    $io_sort_spill_percent                   = '0.8'
    $mapred_reduce_parallel_copies           = '10'
    $mapred_submit_replication               = '1'
    $mapred_reduce_tasks                     = '30'
    $mapred_userlog_retain_hours             = '168'
    $io_sort_mb				     = '512'
    $mapred_child_java_opts		     = ' -Xmx2147483648'
    $mapred_job_reuse_jvm_num_tasks	     = '10'
    $mapred_map_tasks_speculative_execution  = 'false'
    $mapred_reduce_tasks_speculative_execution = 'false'
    $mapred_reduce_slowstart_completed_maps  = '0.98'
    $mapred_tasktracker_map_tasks_maximum    = '8'
    $mapred_tasktracker_reduce_tasks_maximum = '8'
}
