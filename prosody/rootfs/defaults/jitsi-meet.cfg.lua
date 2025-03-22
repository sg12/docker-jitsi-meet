Component "internal-muc.meet.jitsi" "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_room_locking = false
    muc_room_default_public_jids = true
    modules_enabled = { "muc_hide_all"; "muc_filter_access"; }
    muc_filter_whitelist = "auth.meet.jitsi"

VirtualHost "recorder.meet.jitsi"
    authentication = "internal_hashed"
    ssl = {
        key = "/config/certs/recorder.meet.jitsi.key";
        certificate = "/config/certs/recorder.meet.jitsi.crt";
    }

Component "muc.meet.jitsi" "muc"
    restrict_room_creation = true
    storage = "memory"
    modules_enabled = { "muc_meeting_id"; "polls"; "muc_domain_mapper"; }
    muc_room_locking = false
    muc_room_default_public_jids = true

Component "focus.meet.jitsi" "client_proxy"
    target_address = "focus@auth.meet.jitsi"

Component "speakerstats.meet.jitsi" "speakerstats_component"
    muc_component = "muc.meet.jitsi"

Component "conferenceduration.meet.jitsi" "conference_duration_component"
    muc_component = "muc.meet.jitsi"

Component "endconference.meet.jitsi" "end_conference"
    muc_component = "muc.meet.jitsi"

Component "avmoderation.meet.jitsi" "av_moderation_component"
    muc_component = "muc.meet.jitsi"

Component "lobby.meet.jitsi" "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_room_locking = false
    muc_room_default_public_jids = true

Component "breakout.meet.jitsi" "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_room_locking = false
    muc_room_default_public_jids = true
    modules_enabled = { "muc_meeting_id"; "polls"; }
