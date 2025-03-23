// Jitsi Meet configuration.

var config = {};

config.hosts = {};
config.hosts.domain = 'meet.jitsi';

var subdir = '<!--# echo var="subdir" default="" -->';
var subdomain = '<!--# echo var="subdomain" default="" -->';
if (subdir.startsWith('<!--')) {
    subdir = '';
}
if (subdomain) {
    subdomain = subdomain.substring(0,subdomain.length-1).split('.').join('_').toLowerCase() + '.';
}
config.hosts.muc = 'muc.' + subdomain + 'meet.jitsi';
config.bosh = 'https://jitsi-connectrm-test.ru:8443/' + subdir + 'http-bind';
config.websocket = 'wss://jitsi-connectrm-test.ru:8443/' + subdir + 'xmpp-websocket';
config.bridgeChannel = {
    preferSctp: true
};


// Video configuration.
//

config.resolution = 240;
config.constraints = {
    video: {
        height: { ideal: 180, max: 720, min: 180 },
        width: { ideal: 320, max: 1280, min: 320},
    }
};

config.startVideoMuted = 1;
config.startWithVideoMuted = true;

config.flags = {
    sourceNameSignaling: true,
    sendMultipleVideoStreams: true,
    receiveMultipleVideoStreams: true
};

// ScreenShare Configuration.
//

// Audio configuration.
//

config.enableNoAudioDetection = true;
config.enableTalkWhileMuted = false;
config.disableAP = false;
config.disableAGC = false;

// config.audioQuality = {
//     stereo: false,
//     noiseSuppression: true
// };

config.noiseSuppression = true;

// config.audioConstraints = {
//     autoGainControl: true,
//     echoCancellation: true,
//     noiseSuppression: true
// };



config.startAudioOnly = true;
config.startAudioMuted = 10;
config.startWithAudioMuted = false;
config.startSilent = false;
config.enableOpusRed = false;
config.disableAudioLevels = false;
config.enableNoisyMicDetection = true;


// Peer-to-Peer options.
//

config.p2p = {
    enabled: true,
    codecPreferenceOrder: ["AV1", "VP9", "VP8", "H264"],
    mobileCodecPreferenceOrder: ["VP8", "VP9", "H264", "AV1"]
};

// Breakout Rooms
//

config.hideAddRoomButton = false;


// Etherpad
//

// Recording.
//

// Local recording configuration.
config.localRecording = {
    disable: false,
    notifyAllParticipants: false,
    disableSelfRecording: false
};


// Analytics.
//

config.analytics = {};

// Dial in/out services.
//


// Calendar service integration.
//

config.enableCalendarIntegration = false;

// Invitation service.
//

// Miscellaneous.
//

// Prejoin page.
config.prejoinConfig = {
    enabled: false,

    // Hides the participant name editing field in the prejoin screen.
    hideDisplayName: false
};

// List of buttons to hide from the extra join options dropdown on prejoin screen.
// Welcome page.
config.welcomePage = {
    disabled: false
};

// Close page.
config.enableClosePage = false;

// Default language.
// Require users to always specify a display name.
config.requireDisplayName = false;

// Chrome extension banner.
// Disables profile and the edit of all fields from the profile settings (display name and email)
config.disableProfile = false;

// Room password (false for anything, number for max digits)
config.roomPasswordNumberOfDigits = false;
// Advanced.
//

// Transcriptions (subtitles and buttons can be configured in interface_config)
config.transcription = {
    enabled: false,
    translationLanguages: [],
    translationLanguagesHead: ['en'],
    useAppLanguage: true,
    preferredLanguage: 'en-US',
    disableStartForAll: false,
    autoCaptionOnRecord: false,
};

// Dynamic branding
// Deployment information.
//

config.deploymentInfo = {};

// Deep Linking
config.disableDeepLinking = false;

// P2P preferred codec
// Video quality settings.
//

config.videoQuality = {};
config.videoQuality.codecPreferenceOrder = ["VP9", "VP8", "H264", "AV1"];
config.videoQuality.mobileCodecPreferenceOrder = ["VP8", "VP9", "H264", "AV1"];
config.videoQuality.enableAdaptiveMode = true;

config.videoQuality.av1 = {};

config.videoQuality.h264 = {};

config.videoQuality.vp8 = {};

config.videoQuality.vp9 = {};

// Reactions
config.disableReactions = false;

// Polls
config.disablePolls = false;

// Configure toolbar buttons
// Hides the buttons at pre-join screen
// Configure remote participant video menu
config.remoteVideoMenu = {
    disabled: false,
    disableKick: false,
    disableGrantModerator: false,
    disablePrivateChat: false
};

// Configure e2eping
config.e2eping = {
    enabled: false
};



// Settings for the Excalidraw whiteboard integration.
config.whiteboard = {
    enabled: false,
};

// JaaS support: pre-configure image if JAAS_APP_ID was set.
// Testing
config.testing = {
    enableCodecSelectionAPI: true
};

config.disableMobileAppPromo = true;
