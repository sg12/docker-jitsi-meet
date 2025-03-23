var config = {
    // Основные настройки доменов
    hosts: {
        domain: 'jitsi-connectrm-test.ru',
        muc: 'muc.jitsi-connectrm-test.ru',
        bridge: 'jvb.jitsi-connectrm-test.ru',
        anonymousdomain: 'guest.jitsi-connectrm-test.ru'
    },

    // BOSH и WebSocket соединения
    bosh: 'https://jitsi-connectrm-test.ru:8443/http-bind',
    websocket: 'wss://jitsi-connectrm-test.ru:8443/xmpp-websocket',
    serviceUrl: 'https://jitsi-connectrm-test.ru:8443/http-bind',

    // Видео настройки
    resolution: 240,
    constraints: {
        video: {
            height: { ideal: 180, max: 720, min: 180 },
            width: { ideal: 320, max: 1280, min: 320 }
        }
    },
    startVideoMuted: 1,
    startWithVideoMuted: true,

    // Флаги для видео
    flags: {
        sourceNameSignaling: true,
        sendMultipleVideoStreams: true,
        receiveMultipleVideoStreams: true
    },

    // Настройки экрана
    desktopSharingFrameRate: {
        min: 5,
        max: 30
    },

    // Аудио настройки
    enableNoAudioDetection: true,
    enableTalkWhileMuted: false,
    disableAP: false,
    disableAGC: false,
    noiseSuppression: true,
    startAudioOnly: true,
    startAudioMuted: 0,
    startWithAudioMuted: false,
    startSilent: false,
    enableNoisyMicDetection: true,

    // P2P настройки
    p2p: {
        enabled: true,
        codecPreferenceOrder: ["AV1", "VP9", "VP8", "H264"],
        stunServers: [
            { urls: 'stun:meet-jit-si-turnrelay.jitsi.net:443' }
        ]
    },

    // Breakout Rooms
    hideAddRoomButton: false,

    // Локальная запись
    localRecording: {
        disable: false,
        notifyAllParticipants: false,
        disableSelfRecording: false
    },

    // Видео качество
    videoQuality: {
        codecPreferenceOrder: ["VP9", "VP8", "H264", "AV1"],
        mobileCodecPreferenceOrder: ["VP8", "VP9", "H264", "AV1"],
        enableAdaptiveMode: true
    },

    // Дополнительные настройки
    prejoinConfig: {
        enabled: true,
        hideDisplayName: false
    },
    welcomePage: {
        disabled: false
    },
    enableClosePage: false,
    requireDisplayName: false,
    disableProfile: false,

    // Реакции и опросы
    disableReactions: false,
    disablePolls: false,

    // Тестирование
    testing: {
        enableCodecSelectionAPI: true,
        octo: { probability: 1 }
    },

    disableMobileAppPromo: true
};
