# == Class cdh5::hadoop::master
# Wrapper class for Hadoop master node services:
# - NameNode
# - ResourceManager and HistoryServer (YARN)
# OR
# - JobTracker (MRv1).
#
class cdh5::hadoop::master {
    Class['cdh5::hadoop'] -> Class['cdh5::hadoop::master']

    include cdh5::hadoop::namenode::primary

    # YARN uses ResourceManager and HistoryServer,
    # NOT JobTracker.
    if $::cdh5::hadoop::use_yarn {
        include cdh5::hadoop::resourcemanager
        include cdh5::hadoop::historyserver
    }
    # MRv1 just uses JobTracker
    else {
        include cdh5::hadoop::jobtracker
    }
}
