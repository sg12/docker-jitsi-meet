admins = { "focus@${XMPP_AUTH_DOMAIN}", "jvb@${XMPP_AUTH_DOMAIN}", "jibri@${XMPP_AUTH_DOMAIN}", "jigasi@${XMPP_AUTH_DOMAIN}" }
unlimited_jids = { "focus@${XMPP_AUTH_DOMAIN}", "jvb@${XMPP_AUTH_DOMAIN}" }
plugin_paths = { "/prosody-plugins/", "/prosody-plugins-custom", "/prosody-plugins-contrib" }

modules_enabled = {
    "roster"; "saslauth"; "tls"; "disco"; "private"; "limits"; "version"; "ping"; "posix"; "http_health";
    "bosh"; "websocket"; "pubsub"; "presence_identity";
}
modules_disabled = {}

http_ports = { 5280 }
http_interfaces = { "*", "::" }
c2s_require_encryption = true
c2s_ports = { 5222 }
c2s_interfaces = { "*", "::" }

log = {
    { levels = {min = "info"}, timestamps = "%Y-%m-%d %X", to = "console" };
}

muc_mapper_domain_base = "${XMPP_DOMAINS}"
http_default_host = "${XMPP_DOMAINS%%,*}"  -- Первый домен из списка

consider_bosh_secure = true
consider_websocket_secure = true

VirtualHost "${XMPP_AUTH_DOMAIN}"
    authentication = "internal_hashed"
    ssl = {
        key = "/config/certs/${XMPP_AUTH_DOMAIN}.key";
        certificate = "/config/certs/${XMPP_AUTH_DOMAIN}.crt";
    }
    modules_enabled = { "limits_exception"; "smacks"; }

Include "conf.d/*.cfg.lua"
