VirtualHost "jitsi-connectrm-test.ru"
    authentication = "internal_plain"
    modules_enabled = { "disco" }

Component "muc.jitsi-connectrm-test.ru" "muc"
    restrict_room_creation = false
    modules_enabled = { "muc_meeting_id" }
