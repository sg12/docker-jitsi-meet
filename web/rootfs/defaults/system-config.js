{{ $CONFIG_PREFIX := .Env.WEB_CONFIG_PREFIX | default "// Jitsi Meet configuration.\n" -}}
{{ $BOSH_RELATIVE := .Env.BOSH_RELATIVE | default "false" | toBool -}}
{{ $ENABLE_AUTH := .Env.ENABLE_AUTH | default "false" | toBool -}}
{{ $ENABLE_AUTH_DOMAIN := .Env.ENABLE_AUTH_DOMAIN | default "true" | toBool -}}
{{ $ENABLE_GUESTS := .Env.ENABLE_GUESTS | default "false" | toBool -}}
{{ $ENABLE_SUBDOMAINS := .Env.ENABLE_SUBDOMAINS | default "true" | toBool -}}
{{ $ENABLE_XMPP_WEBSOCKET := .Env.ENABLE_XMPP_WEBSOCKET | default "1" | toBool -}}
{{ $PUBLIC_URL := .Env.PUBLIC_URL | default "https://localhost:8443" -}}
{{ $HOSTNAME := trimPrefix "https://" (trimSuffix ":${HTTPS_PORT}" $PUBLIC_URL) -}}
{{ $XMPP_AUTH_DOMAIN := .Env.XMPP_AUTH_DOMAIN | default (printf "auth.%s" $HOSTNAME) -}}
{{ $XMPP_DOMAIN := .Env.XMPP_DOMAIN | default $HOSTNAME -}}
{{ $XMPP_GUEST_DOMAIN := .Env.XMPP_GUEST_DOMAIN | default (printf "guest.%s" $HOSTNAME) -}}
{{ $XMPP_MUC_DOMAIN := .Env.XMPP_MUC_DOMAIN | default (printf "muc.%s" $HOSTNAME) -}}
{{ $XMPP_MUC_DOMAIN_PREFIX := (split "." $XMPP_MUC_DOMAIN)._0  -}}
{{ $JVB_PREFER_SCTP := .Env.JVB_PREFER_SCTP | default "1" | toBool -}}

{{ join "\n" (splitList "\\n" $CONFIG_PREFIX) }}
var config = {};

config.hosts = {};
config.hosts.domain = '{{ $XMPP_DOMAIN }}';

{{ if $ENABLE_SUBDOMAINS -}}
var subdir = '<!--# echo var="subdir" default="" -->';
var subdomain = '<!--# echo var="subdomain" default="" -->';
if (subdir.startsWith('<!--')) {
    subdir = '';
}
if (subdomain) {
    subdomain = subdomain.substring(0,subdomain.length-1).split('.').join('_').toLowerCase() + '.';
}
config.hosts.muc = '{{ $XMPP_MUC_DOMAIN_PREFIX }}.' + subdomain + '{{ $XMPP_DOMAIN }}';
{{ else -}}
config.hosts.muc = '{{ $XMPP_MUC_DOMAIN }}';
{{ end -}}

{{ if $ENABLE_AUTH -}}
{{ if $ENABLE_GUESTS -}}
config.hosts.anonymousdomain = '{{ $XMPP_GUEST_DOMAIN }}';
{{ end -}}
{{ if $ENABLE_AUTH_DOMAIN -}}
config.hosts.authdomain = '{{ $XMPP_AUTH_DOMAIN }}';
{{ end -}}
{{ end -}}

{{ if $BOSH_RELATIVE -}}
{{ if $ENABLE_SUBDOMAINS -}}
config.bosh = '/'+ subdir + 'http-bind';
{{ else -}}
config.bosh = '/http-bind';
{{ end -}}
{{ else -}}
{{ if $ENABLE_SUBDOMAINS -}}
config.bosh = '{{ $PUBLIC_URL }}/' + subdir + 'http-bind';
{{ else -}}
config.bosh = '{{ $PUBLIC_URL }}/http-bind';
{{ end -}}
{{ end -}}

{{ if $ENABLE_XMPP_WEBSOCKET -}}
{{ if $ENABLE_SUBDOMAINS -}}
config.websocket = 'wss://{{ $HOSTNAME }}:${HTTPS_PORT}/' + subdir + 'xmpp-websocket';
{{ else -}}
config.websocket = 'wss://{{ $HOSTNAME }}:${HTTPS_PORT}/xmpp-websocket';
{{ end -}}
{{ end -}}

config.bridgeChannel = {
    preferSctp: {{ $JVB_PREFER_SCTP }}
};
