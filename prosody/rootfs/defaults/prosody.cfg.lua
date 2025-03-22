admins = { "focus@${XMPP_AUTH_DOMAIN}", "jvb@${XMPP_AUTH_DOMAIN}", "jibri@${XMPP_AUTH_DOMAIN}", "jigasi@${XMPP_AUTH_DOMAIN}" }
unlimited_jids = { "focus@${XMPP_AUTH_DOMAIN}", "jvb@${XMPP_AUTH_DOMAIN}" }
plugin_paths = { "/prosody-plugins/", "/prosody-plugins-custom", "/prosody-plugins-contrib" }

modules_enabled = {
    "roster"; "saslauth"; "tls"; "disco"; "private"; "limits"; "version"; "ping"; "posix"; "http_health";
    "bosh"; "websocket"; "pubsub"; "presence_identity"; "admin_shell";
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
    storage = "internal"
    ssl = {
        key = "/config/certs/${XMPP_AUTH_DOMAIN}.key";
        certificate = "/config/certs/${XMPP_AUTH_DOMAIN}.crt";
    }
    modules_enabled = { "limits_exception"; "smacks"; }

Include "conf.d/*.cfg.lua"

VirtualHost "meet.jitsi"
    authentication = "jitsi-anonymous"
    ssl = {
        key = "/config/certs/meet.jitsi.key";
        certificate = "/config/certs/meet.jitsi.crt";
    }
    modules_enabled = {
        "bosh"; "websocket"; "smacks"; "speakerstats"; "conference_duration"; "room_metadata";
        "end_conference"; "muc_lobby_rooms"; "muc_breakout_rooms"; "av_moderation";
    }
    main_muc = "muc.meet.jitsi"
    lobby_muc = "lobby.meet.jitsi"
    breakout_rooms_muc = "breakout.meet.jitsi"
    speakerstats_component = "speakerstats.meet.jitsi"
    conference_duration_component = "conferenceduration.meet.jitsi"
    end_conference_component = "endconference.meet.jitsi"
    av_moderation_component = "avmoderation.meet.jitsi"
