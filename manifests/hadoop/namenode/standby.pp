# == Class cdh5::hadoop::namenode::standby
# Hadoop Standby NameNode.  Include this class instead of
# cdh5::hadoop::master on your HA standby NameNode(s).  This
# will bootstrap the standby dfs.name.dir with the contents
# from your primary active NameNode.
#
# See README.md for more documentation.
#
# NOTE: Your JournalNodes should be running before this class is applied.
#
class cdh5::hadoop::namenode::standby inherits cdh5::hadoop::namenode {
    # Fail if nameservice_id isn't set.
    if (!$::cdh5::hadoop::ha_enabled) {
        fail('Cannot use Standby NameNode in a non HA setup.  Set $nameservice_id on the cdh5::hadoop class to enable HA.')
    }

    # Override the namenode -format command to bootstrap this
    # standby NameNode's dfs.name.dir with the data from the
    # active NameNode.
    Exec['hadoop-namenode-format'] {
        command     => '/usr/bin/hdfs namenode -bootstrapStandby',
    }
}
