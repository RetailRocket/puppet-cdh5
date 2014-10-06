#

class { '::cdh5::hadoop':
    namenode_hosts => ['localhost'],
    dfs_name_dir   => '/var/lib/hadoop/name',
}

# resourcemanager requires namenode
include cdh5::hadoop::master
include cdh5::hadoop::resourcemanager
