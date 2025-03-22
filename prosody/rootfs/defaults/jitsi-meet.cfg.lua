Component "internal-muc.meet.jitsi" "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_room_locking = false
    muc_room_default_public_jids = true
    modules_enabled = { "muc_hide_all"; "muc_filter_access"; }
    muc_filter_whitelist = "${XMPP_AUTH_DOMAIN}"

VirtualHost "${XMPP_RECORDER_DOMAIN}"
    authentication = "internal_hashed"
    ssl = {
        key = "/config/certs/${XMPP_RECORDER_DOMAIN}.key";
        certificate = "/config/certs/${XMPP_RECORDER_DOMAIN}.crt";
    }
