#

class { '::cdh5::hadoop':
    namenode_hosts => ['localhost'],
    dfs_name_dir   => '/var/lib/hadoop/name',
}

include cdh5::hadoop::master
