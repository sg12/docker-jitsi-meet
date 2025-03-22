-- Первый домен из XMPP_DOMAINS
local FIRST_DOMAIN = "${XMPP_DOMAINS%%,*}"

Component "conference." .. FIRST_DOMAIN .. " " "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_room_locking = false
    muc_room_default_public_jids = true
    modules_enabled = { "muc_meeting_id"; "muc_domain_mapper"; "polls"; }

Component "internal-muc.meet.jitsi" "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_room_locking = false
    muc_room_default_public_jids = true
    modules_enabled = { "muc_hide_all"; "muc_filter_access"; }
    muc_filter_whitelist = "${XMPP_AUTH_DOMAIN}"

Component "focus." .. FIRST_DOMAIN .. " " "client_proxy"
    target_address = "focus@${XMPP_AUTH_DOMAIN}"

Component "speakerstats." .. FIRST_DOMAIN .. " " "speakerstats_component"
    muc_component = "muc." .. FIRST_DOMAIN

Component "conferenceduration." .. FIRST_DOMAIN .. " " "conference_duration_component"
    muc_component = "muc." .. FIRST_DOMAIN

Component "endconference." .. FIRST_DOMAIN .. " " "end_conference"
    muc_component = "muc." .. FIRST_DOMAIN

Component "avmoderation." .. FIRST_DOMAIN .. " " "av_moderation_component"
    muc_component = "muc." .. FIRST_DOMAIN

Component "lobby." .. FIRST_DOMAIN .. " " "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_room_locking = false
    muc_room_default_public_jids = true

Component "breakout." .. FIRST_DOMAIN .. " " "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_room_locking = false
    muc_room_default_public_jids = true
    modules_enabled = { "muc_meeting_id"; "polls"; }

Component "metadata." .. FIRST_DOMAIN .. " " "room_metadata_component"
    muc_component = "muc." .. FIRST_DOMAIN
    breakout_rooms_component = "breakout." .. FIRST_DOMAIN

VirtualHost "${XMPP_RECORDER_DOMAIN}"
    authentication = "internal_hashed"
    ssl = {
        key = "/config/certs/${XMPP_RECORDER_DOMAIN}.key";
        certificate = "/config/certs/${XMPP_RECORDER_DOMAIN}.crt";
    }
