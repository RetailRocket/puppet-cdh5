# == Class cdh5::oozie::defaults
#
class cdh5::oozie::defaults {
    $database                               = 'postgresql'

    $jdbc_driver                            = 'org.postgresql.Driver'
    $jdbc_protocol                          = 'postgresql'
    $jdbc_database                          = 'oozie'
    $jdbc_host                              = 'localhost'
    $jdbc_port                              = 5432
    $jdbc_username                          = 'oozie'
    $jdbc_password                          = 'oozie'

    $smtp_host                              = undef
    $smtp_port                              = 25
    $smtp_from_email                        = undef
    $smtp_username                          = undef
    $smtp_password                          = undef

    $authorization_service_security_enabled = false

    # Default puppet paths to template config files.
    # This allows us to use custom template config files
    # if we want to override more settings than this
    # module yet supports.
    $oozie_site_template                    = 'cdh5/oozie/oozie-site.xml.erb'
    $oozie_env_template                     = 'cdh5/oozie/oozie-env.sh.erb'
}
