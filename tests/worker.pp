#

class { '::cdh5::hadoop':
    namenode_hosts  => 'localhost',
    dfs_name_dir    => '/var/lib/hadoop/name',
    datanode_mounts => '/tmp',
}

include cdh5::hadoop::worker
