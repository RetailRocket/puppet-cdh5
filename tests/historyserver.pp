#

class { '::cdh5::hadoop':
    namenode_hosts => ['localhost'],
    dfs_name_dir   => '/var/lib/hadoop/name',
}

# historyserver requires namenode
include cdh5::hadoop::master
include cdh5::hadoop::historyserver
