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

-- Виртуальные хосты для всех доменов из XMPP_DOMAINS
<% for domain in string.gmatch("${XMPP_DOMAINS}", "[^,]+") do %>
VirtualHost "<%= domain %>"
    authentication = "token"
    app_id = "${JWT_APP_ID}"
    app_secret = "${JWT_APP_SECRET}"
    allow_empty_token = false
    ssl = {
        key = "/config/certs/<%= domain %>.key";
        certificate = "/config/certs/<%= domain %>.crt";
    }
    modules_enabled = {
        "bosh"; "websocket"; "smacks"; "speakerstats"; "conference_duration"; "room_metadata";
        "end_conference"; "muc_lobby_rooms"; "muc_breakout_rooms"; "av_moderation"; "token_verification";
    }
    main_muc = "muc.<%= domain %>"
    lobby_muc = "lobby.<%= domain %>"
    breakout_rooms_muc = "breakout.<%= domain %>"
    speakerstats_component = "speakerstats.<%= domain %>"
    conference_duration_component = "conferenceduration.<%= domain %>"
    end_conference_component = "endconference.<%= domain %>"
    av_moderation_component = "avmoderation.<%= domain %>"
<% end %>

VirtualHost "${XMPP_AUTH_DOMAIN}"
    authentication = "internal_hashed"
    ssl = {
        key = "/config/certs/${XMPP_AUTH_DOMAIN}.key";
        certificate = "/config/certs/${XMPP_AUTH_DOMAIN}.crt";
    }
    modules_enabled = { "limits_exception"; "smacks"; }

Include "conf.d/*.cfg.lua"
