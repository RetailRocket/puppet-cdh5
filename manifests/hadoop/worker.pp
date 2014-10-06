# == Class cdh5::hadoop::worker
# Wrapper class for Hadoop Worker node services:
# - DataNode
# - NodeManager (YARN)
# OR
# - TaskTracker (MRv1)
#
# This class will attempt to create and manage the required
# local worker directories defined in the $datanode_mounts array.
# You must make sure that the paths defined in $datanode_mounts are
# formatted and mounted properly yourself; The CDH4 module does not
# manage them.
#
class cdh5::hadoop::worker {
    Class['cdh5::hadoop']->Class['cdh5::hadoop::worker']

    cdh5::hadoop::worker::paths { $::cdh5::hadoop::datanode_mounts: }

    class { 'cdh5::hadoop::datanode':
        require => Cdh5::Hadoop::Worker::Paths[$::cdh5::hadoop::datanode_mounts],
    }

    # YARN uses NodeManager.
    if $::cdh5::hadoop::use_yarn {
        class { 'cdh5::hadoop::nodemanager':
            require => Cdh5::Hadoop::Worker::Paths[$::cdh5::hadoop::datanode_mounts],
        }
    }
    # MRv1 uses TaskTracker.
    else {
        class { 'cdh5::hadoop::tasktracker':
            require => Cdh5::Hadoop::Worker::Paths[$::cdh5::hadoop::datanode_mounts],
        }
    }
}
