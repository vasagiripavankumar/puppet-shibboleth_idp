# Type: shibboleth_idp::attribute_filter::dataconnector
#
# This type represents a data connector for resolving attributes
#

define shibboleth_idp::attribute_resolver::dataconnector (
  $id = $name,
  $type = undef,

  $ldap_url = undef,
  $ldap_base_dn = undef,
  $ldap_principal = undef,
  $ldap_principal_credential = undef,
  $ldap_use_start_tls = undef,
  $ldap_filter_template = undef,
  $ldap_filter_tls_trust_id = undef,
  $ldap_filter_tls_trust_cert = undef,
  $ldap_return_attributes = undef,
  $ldap_trust_cert_source = undef,
) {

  concat::fragment { "attribute_resolver_dataconnector_${id}":
    target  => 'attribute-resolver.xml',
    order   => '80',
    content => template("${module_name}/shibboleth/attribute_resolver/_dataconnector.erb"),
  }

  if $type == 'LDAPDirectory' {
    concat::fragment { "dataconnector_properties_${id}":
      target  => 'dataconnectors.properties',
      order   => '10',
      content => template("${module_name}/shibboleth/attribute_resolver/_ldap_properties.erb"),
    }
  }

  if $ldap_trust_cert_source {
    file { "${shibboleth_idp::shib_install_base}/${ldap_filter_tls_trust_cert}":
      ensure => file,
      source => $ldap_trust_cert_source,
      owner  => $shibboleth_idp::shib_user,
      group  => $shibboleth_idp::shib_group,
      mode   => '0644',
      notify => Class['shibboleth_idp::service'],
    }
  }
}
