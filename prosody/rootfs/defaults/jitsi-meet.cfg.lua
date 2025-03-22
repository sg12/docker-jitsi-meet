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

Component "conference.joinrm-svz.ru" "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_room_locking = false
    muc_room_default_public_jids = true
    modules_enabled = { "muc_meeting_id"; "muc_domain_mapper"; "polls"; }

Component "lobby.joinrm-svz.ru" "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_room_locking = false
    muc_room_default_public_jids = true

Component "breakout.joinrm-svz.ru" "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_room_locking = false
    muc_room_default_public_jids = true
    modules_enabled = { "muc_meeting_id"; "polls"; }

Component "speakerstats.joinrm-svz.ru" "speakerstats_component"
    muc_component = "muc.joinrm-svz.ru"

Component "conferenceduration.joinrm-svz.ru" "conference_duration_component"
    muc_component = "muc.joinrm-svz.ru"

Component "endconference.joinrm-svz.ru" "end_conference"
    muc_component = "muc.joinrm-svz.ru"

Component "avmoderation.joinrm-svz.ru" "av_moderation_component"
    muc_component = "muc.joinrm-svz.ru"

Component "muc.joinrm-svz.ru" "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_room_locking = false
    muc_room_default_public_jids = true
    modules_enabled = { "muc_meeting_id"; "muc_domain_mapper"; "polls"; }
